#!/usr/bin/env bash
#
# Static link generator
# Created By Roberta Brandao

#linkfile

BASEDIR=$(dirname "$0")
CONF_LINK=./$BASEDIR/conf_link.yml
RENDER_DIR=./public


#readarray LIST_ARR < <(yq e '.site_url | keys | .[]' ${CONF_LINK})

# Templating functions
player_template () {
export EP_NAME=${1//[$'\n\r']}
export EP_AUDIO=${2//[$'\n\r ']}
export EP_DESCRIPTION=${3//[$'\n\r']}
export EP_DURATION=${4//[$'\n\r']}

#creating player by template
envsubst < $BASEDIR/player.tpl

unset EP_NAME
unset EP_AUDIO
unset EP_DESCRIPTION
unset EP_DURATION
}

#create_list_principal () { 
#for list in "${LIST_ARR[@]}"
#do
#   button_template "$list/"  "$list"
#done
#}

#create_index_template () {
#export SITE_TITLE=$(yq e '.site.title'  ${CONF_LINK})
#export BUTTONS=$(create_list_principal)
#
#   #creating render dirs
#  # for list in "${LIST_ARR[@]}"
#  # do
#  #     create_render_dir "${RENDER_DIR}/${list//[$'\n\r\t ']}/assets"
#  # done
#
##Creating index page
#envsubst < $BASEDIR/index.tpl > $RENDER_DIR/index.html
#
##copy css and png to assets
#create_render_dir "$RENDER_DIR/assets"
#cp $BASEDIR/style.tpl $RENDER_DIR/assets/style.css
#cp $BASEDIR/image.png $RENDER_DIR/assets/image.png
#
#unset SITE_TITLE
#unset BUTTONS
#}

create_render_dir () {
[ -d ${1} ] || mkdir -p ${1}
}

create_index_subgroups () {

create_render_dir "$RENDER_DIR/assets"

export PLAYERS=''
# creating buttons list
while IFS= read -r line
  do
      NAME=$(cat <<< "$line" |  cut -d$'\t' -f1)
      AUDIO=$(cat <<< "$line" |  cut -d$'\t' -f2)
      DESCRIPTION=$(cat <<< "$line" |  cut -d$'\t' -f3)
      DURATION=$(cat <<< "$line" |  cut -d$'\t' -f4)

    PLAYERS+=$(player_template "${NAME}" "${AUDIO}" "${DESCRIPTION}" "${DURATION}")
  done < <(yq e ".episodes" ${CONF_LINK} -o=tsv | sed '1d')

envsubst < $BASEDIR/index.tpl > ${RENDER_DIR}/index.html

# minify css files
cp $BASEDIR/style.tpl ${RENDER_DIR}/assets/style.css
    
cp $BASEDIR/image.png ${RENDER_DIR}/assets/image.png

unset PLAYERS
}

minify () {
#minify css and javascript
cat $1 | sed \
        -e "s|/\*\(\\\\\)\?\*/|/~\1~/|g" \
        -e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" \
        -e "s|\([^:/]\)//.*$|\1|" \
        -e "s|^//.*$||" \
       | tr '\n' ' ' \
       | sed \
        -e "s|/\*[^*]*\*\+\([^/][^*]*\*\+\)*/||g" \
        -e "s|/\~\(\\\\\)\?\~/|/*\1*/|g" \
        -e "s|\s\+| |g" \
        -e "s| \([{;:,]\)|\1|g" \
        -e "s|\([{;:,]\) |\1|g" \
       > $2
}

#Execution

#create_index_template
create_index_subgroups
