#!/bin/bash

output="_versioned_src"
shopt -s extglob
while read v; do
  ./tools/version.sh $v
  rm -rf ${output}/${v}/!(src)
  mv ${output}/${v}/src/* ${output}/${v}/
  rm -rf ${output}/${v}/src
done <versions
# always fetch master
./tools/version.sh master
rm -rf ${output}/master/!(src|htmldocs)
mv ${output}/master/htmldocs/media ${output}/media
rm -rf ${output}/master/htmldocs
mv ${output}/master/src/* ${output}/master/
rm -rf ${output}/master/src

shopt -u extglob
