#!/bin/bash

#enable plugin paths for markdown.py
export PYTHONPATH="${PWD}/tools/plugins:${PWD}/tools/plugins/gfm:${PYTHONPATH}"

#convert all .md files in given directory
function build() {
  printf "%s" "processing ${1} :"
  f=$(find $1 -type f -name "*.md")
  export DOCNAV="$(cat $1/../navigation.tpl)"
  for file in $f; do
    printf "%s" "#"
    txt=`markdown_py -x callouts -x partial_gfm -x anchors_away -x foldouts -x meta -x def_list -x attr_list $file`
    CONTENT=$txt cheetah fill --stdout --env src/base.tpl > $1/`basename ${file%.*}`.html
    rm  $file
  done 
  printf "\n%s\n" "...complete"
}

#remove extraneous files after build
function cleandir() {  
  echo ${1}
  [ -d ${1}/.git ] && rm -rf ${1}/.git
  [ -f ${1}/.gitignore ] && rm ${1}/.gitignore
  [ -f ${1}/base.tpl ] && rm ${1}/base.tpl
  [ -f ${1}/navigation.tpl ] && rm ${1}/navigation.tpl
}

output="_build"
[ -d ${output} ] && rm -rf ${output}

shopt -s extglob
while read v; do
  ./tools/version.sh -d ${output} $v
  rm -rf ${output}/${v}/!(src)
  mv ${output}/${v}/src/* ${output}/${v}/
  rm -rf ${output}/${v}/src
  # process all directories
  for d in ${output}/${v}/*/ ; do
    build $d
  done
  #remove extraneous files
  cleandir ${output}/${v}/
  
done <versions

# always fetch master
./tools/version.sh -d ${output} master
rm -rf ${output}/master/!(src|htmldocs)
mv ${output}/master/htmldocs/media ${output}/media
rm -rf ${output}/master/htmldocs
mv ${output}/master/src/* ${output}/master/
rm -rf ${output}/master/src
for d in ${output}/master/*/ ; do
    build $d
done
cleandir ${output}/master/
#rename master to dev, as it represent dev version of docs
mv ${output}/master ${output}/dev

shopt -u extglob
