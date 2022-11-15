#!/usr/bin/env bash
#
# Static link generator
# Created By Roberta Brandao

#linkfile

BASEDIR=$(dirname "$0")
CONF_LINK=./$BASEDIR/conf_link.yml
RENDER_DIR=./public

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

rss_item_template () {
export EP_NAME=${1//[$'\n\r']}
export EP_AUDIO=${2//[$'\n\r ']}
export EP_DESCRIPTION=${3//[$'\n\r']}
export EP_DURATION=${4//[$'\n\r']}

#creating player by template
envsubst < $BASEDIR/rss_item.tpl

unset EP_NAME
unset EP_AUDIO
unset EP_DESCRIPTION
unset EP_DURATION
}

create_render_dir () {
[ -d ${1} ] || mkdir -p ${1}
}

create_index_subgroups () {
# Default site vars
export SITE_TITLE=$(yq e '.site.title'  ${CONF_LINK})
export SITE_DESC=$(yq e '.site.description'  ${CONF_LINK})
export SITE_IMG=$(yq e '.site.image'  ${CONF_LINK})
export SITE_EMAIL=$(yq e '.site.email'  ${CONF_LINK})
export SITE_AUTHOR=$(yq e '.site.author'  ${CONF_LINK})
export SITE_URL=$(yq e '.site.url'  ${CONF_LINK})

export PLAYERS=''
export RSS_ITEM=''
# creating buttons list
while IFS= read -r line
  do
      NAME=$(cat <<< "$line" |  cut -d$'\t' -f1)
      AUDIO=$(cat <<< "$line" |  cut -d$'\t' -f2)
      DESCRIPTION=$(cat <<< "$line" |  cut -d$'\t' -f3)
      DURATION=$(cat <<< "$line" |  cut -d$'\t' -f4)
 
    PLAYERS+=$(player_template "${NAME}" "${AUDIO}" "${DESCRIPTION}" "${DURATION}")
    RSS_ITEM+=$(rss_item_template "${NAME}" "${AUDIO}" "${DESCRIPTION}" "${DURATION}")
  done < <(yq e ".episodes" ${CONF_LINK} -o=tsv | sed '1d')

create_render_dir "$RENDER_DIR/assets"

envsubst < $BASEDIR/index.tpl > ${RENDER_DIR}/index.html
envsubst < $BASEDIR/rss.tpl > ${RENDER_DIR}/feed.rss

# minify css files
minify $BASEDIR/style.tpl ${RENDER_DIR}/assets/style.css
    
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

create_index_subgroups
