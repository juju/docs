#!/bin/bash
set -ex

watchmedo shell-command   --patterns="*.md;"   --recursive   --command='make doc=$(basename ${watch_src_path})' ../
