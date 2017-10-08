#!/bin/bash

# Usage:
#  source "./common/argument/target.sh"

target=""

for i in "$@"
do
case $i in
    -t=*|--target=*)
    target="${i#*=}"
esac
done 
