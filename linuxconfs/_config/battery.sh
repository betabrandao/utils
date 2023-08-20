#!/bin/bash

BAT_STS=$(acpi -a | grep 'on-line' | wc -l)
CHARGE=$(echo ${BAT_STS} | sed 's/1/Charging/g;s/0/Discharging/g')
BAT=$(acpi -b | grep -E -o '[0-9][0-9][0-9]?%')

[ ${BAT%?} -eq 100 ] && CHARGE="Charged"

# Full and short texts
  echo "Battery: ${BAT} ${CHARGE}"

# Set urgent flag below 5% or use orange below 20%
[ ${BAT%?} -le 5 && ${BAT_STS} -eq 0  ] && exit 33
[ ${BAT%?} -le 20 && ${BAT_STS} -eq 0 ] && echo "#FF8000"

exit 0
