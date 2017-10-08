#!/bin/bash

# Usage:
#  source "./common/argument/format.sh"

format="b"

for i in "$@"
do
case $i in
    -f=*|--format=*)
    format="${i#*=}"
esac
done 
