#!/bin/bash

output_dir="_versioned_src"

usage() { echo "Usage: $0 [-d output_dir] version ..." 1>&2; exit 1; }

# Parse command line options.
while getopts ":d:" o; do
  case "${o}" in
    d)
      output_dir=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))
if [ $# == 0 ]; then
  usage
fi

# Setup the output directory.
echo "Generating versioned source in \"${output_dir}\"..."
mkdir -p "${output_dir}"

# Grab the latest tags and branches.
git fetch

# Fetch each version.
while [ $# -ne 0 ]
do
  version=${1}
  echo "Fetching version \"${version}\"..."
  git branch --track "${version}" "origin/${version}"
  git clone --branch "${version}" --single-branch . "${output_dir}/${version}"
  shift
done
