#!/bin/bash

# Usage:
#  source "./common/argument/web.sh"

web=""

for i in "$@"
do
case $i in
    -w=*|--web=*)
    web="${i#*=}"
esac
done 
