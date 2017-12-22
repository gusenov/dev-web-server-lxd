#!/bin/bash

# Usage:
#  source "./common/argument/folder.sh"

folder=""

for i in "$@"
do
case $i in
    -f=*|--folder=*)
    folder="${i#*=}"
esac
done 
