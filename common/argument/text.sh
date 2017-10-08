#!/bin/bash

# Usage:
#  source "./common/argument/text.sh"

text="Success"

for i in "$@"
do
case $i in
    -t=*|--text=*)
    text="${i#*=}"
esac
done 
