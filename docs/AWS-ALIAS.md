# Criação de scripts para o AWS Cli

Funciona em versões `1.11.24`e posteriores.

Exemplos:

```bash
$ aws myip
$ aws randpass 20
$ aws whoami
```

- coloque o conteúdo abaixo em `~/.aws/cli/alias`

```bash
[toplevel]

# Print IP. Ex. aws myip
myip =
  !f() {
    curl -s ipinfo.io | grep \"ip\" | awk -F'"' '{ print $4}'
  }; f

# Print UID. Ex. aws whoami
whoami =
  !f() {
   aws sts get-caller-identity --query Account --output text
  }; f

# Print UID url Signin. Ex. aws whourl
whourl =
  !f() {
   uid=$(aws whoami)
   echo "https://${uid}.signin.aws.amazon.com/console/"
  }; f

# Create random text by length: Ex. aws randpass 10
randpass =
  !f() {
     env LC_CTYPE=C LC_ALL=C tr -dc "a-zA-Z0-9-_\$\?" < /dev/urandom | head -c ${1}; echo
  } ; f

# Create iam user and attach in group. Ex. aws create-iam user.name groupname
create-iam =
  !f() {
  uid=$(aws whoami)
  pass=$(aws randpass 20)
  aws iam create-user --user-name ${1} | cat
  aws iam create-login-profile --user-name ${1} --password ${pass} --password-reset-required | cat
  aws iam add-user-to-group --user-name ${1} --group-name ${2} | cat
  echo
  echo "https://${uid}.signin.aws.amazon.com/console/"
  echo "user: ${1}"
  echo "Pass: ${pass}"
  echo
  }; f

# Create assume role STS. Ex. aws create-assume-role servicename
create-assume-role =
  !f() {
    aws iam create-role --role-name "${1}" \
      --assume-role-policy-document \
        "{\"Statement\":[{\
            \"Action\":\"sts:AssumeRole\",\
            \"Effect\":\"Allow\",\
            \"Principal\":{\"Service\":\""${2}".amazonaws.com\"},\
            \"Sid\":\"\"\
          }],\
          \"Version\":\"2012-10-17\"\
        }";
  }; f

# Describe EC2 Running Instances. Ex. aws running-instances
running-instances = ec2 describe-instances \
    --filter Name=instance-state-name,Values=running \
    --output table \
    --query 'Reservations[].Instances[].{ID: InstanceId,Hostname: PublicDnsName,Name: Tags[?Key==`Name`].Value | [0],Type: InstanceType, Platform: Platform || `Linux`}'

# Describe EBS Volumes. Ex. aws ebs-volumes
ebs-volumes= ec2 describe-volumes \
    --query 'Volumes[].{VolumeId: VolumeId,State: State,Size: Size,Name: Tags[0].Value,AZ: AvailabilityZone}' \
    --output table

# Describe EC2 AMIs. Ex. aws amazon-linux-amis
amazon-linux-amis = ec2 describe-images \
    --filter \
      Name=owner-alias,Values=amazon \
      Name=name,Values="amzn-ami-hvm-*" \
      Name=architecture,Values=x86_64 \
      Name=virtualization-type,Values=hvm \
      Name=root-device-type,Values=ebs \
      Name=block-device-mapping.volume-type,Values=gp2 \
    --query "reverse(sort_by(Images, &CreationDate))[*].[ImageId,Name,Description]" \
    --output text

# List Security Groups. Ex. aws list-sgs
list-sgs = ec2 describe-security-groups --query "SecurityGroups[].[GroupId, GroupName]" --output text


sg-rules = !f() { aws ec2 describe-security-groups \
    --query "SecurityGroups[].IpPermissions[].[FromPort,ToPort,IpProtocol,join(',',IpRanges[].CidrIp)]" \
    --group-id "$1" --output text; }; f

tostring =
  !f() {
    jp -f "${1}" 'to_string(@)'
  }; f

tostring-with-jq =
  !f() {
    cat "${1}" | jq 'tostring'
  }; f

authorize-my-ip =
  !f() {
    ip=$(aws myip)
    aws ec2 authorize-security-group-ingress --group-id ${1} --cidr $ip/32 --protocol tcp --port 22
  }; f

get-group-id =
  !f() {
    aws ec2 describe-security-groups --filters Name=group-name,Values=${1} --query SecurityGroups[0].GroupId --output text
  }; f

# Authorize MyIP to access ssh port 22. Ex. aws authorize-my-ip-by-name secgroupname
authorize-my-ip-by-name =
  !f() {
    group_id=$(aws get-group-id "${1}")
    aws authorize-my-ip "$group_id"
  }; f

# list all security group port ranges open to 0.0.0.0/0
public-ports = ec2 describe-security-groups \
  --filters Name=ip-permission.cidr,Values=0.0.0.0/0 \
  --query 'SecurityGroups[].{
    GroupName:GroupName,
    GroupId:GroupId,
    PortRanges:
      IpPermissions[?contains(IpRanges[].CidrIp, `0.0.0.0/0`)].[
        join(`:`, [IpProtocol, join(`-`, [to_string(FromPort), to_string(ToPort)])])
      ][]
  }'

# List or set your region
region = !f() { [[ $# -eq 1 ]] && aws configure set region "$1" || aws configure get region; }; f

find-access-key = !f() {
    clear_to_eol=$(tput el)
    for i in $(aws iam list-users --query "Users[].UserName" --output text); do
      printf "\r%sSearching...$i" "${clear_to_eol}"
      result=$(aws iam list-access-keys --output text --user-name "${i}" --query "AccessKeyMetadata[?AccessKeyId=='${1}'].UserName";)
      if [ -n "${result}" ]; then
         printf "\r%s%s is owned by %s.\n" "${lear_to_eol}" "$1" "${result}"
         break
      fi
    done
    if [ -z "${result}" ]; then
      printf "\r%sKey not found." "${clear_to_eol}"
    fi
  }; f

docker-ecr-login =
  !f() {
    region=$(aws configure get region)
    endpoint=$(aws ecr get-authorization-token --region $region --output text --query authorizationData[].proxyEndpoint)
    passwd=$(aws ecr get-authorization-token --region $region --output text --query authorizationData[].authorizationToken | base64 --decode | cut -d: -f2)
    docker login -u AWS -p $passwd $endpoint
  }; f

allow-my-ip =
  !f() {
    my_ip=$(aws myip)
    aws ec2 authorize-security-group-ingress --group-name ${1} --protocol ${2} --port ${3} --cidr $my_ip/32
  }; f

revoke-my-ip =
  !f() {
    my_ip=$(aws myip)
    aws ec2 revoke-security-group-ingress --group-name ${1} --protocol ${2} --port ${3} --cidr $my_ip/32
  }; f

allow-my-ip-all =
  !f() {
    aws allow-my-ip ${1} all all
  }; f

revoke-my-ip-all =
  !f() {
    aws revoke-my-ip ${1} all all
  }; f

mfa-check =
  !f() {
  echo "Checking..."
  names=($(aws iam list-users --output text --query "Users[*].UserName" | cat | xargs))

  for name in "${names[@]}"; do
      user=$(aws iam list-mfa-devices --user-name $name --output text --query "MFADevices[*].UserName")
      if [ -z $user ]; then 
        echo "User: $name - Not MFA Configured";
      else
        echo "User: $name - MFA OK";
      fi
  done

  }; f

# delete IAM user. Ex. aws delete-iam user.name
delete-iam = 
  !f() {
   user=${1}
   echo "Deleting user User: $user"
   
   user_policies=$(aws iam list-user-policies --user-name $user --query 'PolicyNames[*]' --output text)
   
   echo "Deleting user policies: $user_policies"
   for policy in $user_policies; do
     echo "Executing: aws iam delete-user-policy --user-name $user --policy-name $policy"
     aws iam delete-user-policy --user-name $user --policy-name $policy
   done
   
   user_attached_policies=$(aws iam list-attached-user-policies --user-name $user --query 'AttachedPolicies[*].PolicyArn' --output text)
   
   echo "Detaching user attached policies: $user_attached_policies"
   for policy_arn in $user_attached_policies; do
     echo "Executing: aws iam detach-user-policy --user-name $user --policy-arn $policy_arn"
     aws iam detach-user-policy --user-name $user --policy-arn $policy_arn
   done
   
   user_groups=$(aws iam list-groups-for-user --user-name $user --query 'Groups[*].GroupName' --output text)
   
   echo "Detaching user attached group: $user_groups"
   for group in $user_groups; do
     echo "Executing: aws iam remove-user-from-group --user-name $user --group-name $group"
     aws iam remove-user-from-group --user-name $user --group-name $group
   done
   
   user_access_keys=$(aws iam list-access-keys --user-name $user --query 'AccessKeyMetadata[*].AccessKeyId' --output text)
   
   echo "Deleting user access keys: $user_accces_keys"
   for key in $user_access_keys; do
     echo "Executing: aws iam delete-access-key --user-name $user --access-key-id $key"
     aws iam delete-access-key --user-name $user --access-key-id $key
   done

   user_serial_numbers=$(aws iam list-mfa-devices --user-name $name --output text --query "MFADevices[*].SerialNumber")

   echo "Detaching MFA Devices from user profile ${user}"
   for serial_number in user_serial_numbers; do
     echo "Executing: aws iam deactivate-mfa-device --user $user --serial-number $serial_number"
     aws iam deactivate-mfa-device --user $user --serial-number $serial_number
   done
   
   echo "Deleting user login profile"
   echo "aws iam delete-login-profile --user-name $user"
   aws iam delete-login-profile --user-name $user
   
   echo "Deleting user: $user"
   echo "aws iam delete-user --user-name $user"
   aws iam delete-user --user-name $user
  }; f
```
