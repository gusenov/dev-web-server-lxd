#!/bin/bash

# Usage:
#  source "./common/argument/action.sh"

action=""

for i in "$@"
do
case $i in
    -a=*|--action=*)
    action="${i#*=}"
esac
done 
