#!/bin/bash

# Usage:
#  source "./common/argument/file.sh"

file=""

for i in "$@"
do
case $i in
    -f=*|--file=*)
    file="${i#*=}"
esac
done 
