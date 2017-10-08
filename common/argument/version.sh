#!/bin/bash

# Usage:
#  source "./common/argument/version.sh"

version=""

for i in "$@"
do
case $i in
    -v=*|--version=*)
    version="${i#*=}"
esac
done 
