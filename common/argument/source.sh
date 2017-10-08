#!/bin/bash

# Usage:
#  source "./common/argument/source.sh"

source=""

for i in "$@"
do
case $i in
    -s=*|--source=*)
    source="${i#*=}"
esac
done 
