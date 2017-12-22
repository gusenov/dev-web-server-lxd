#!/bin/bash

# Usage:
#  source "./common/argument/general.sh"

general=""

for i in "$@"
do
case $i in
    -g=*|--general=*)
    general="${i#*=}"
esac
done 
