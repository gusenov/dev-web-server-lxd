#!/bin/bash

# Usage:
#  source "./common/argument/site.sh"

site=""

for i in "$@"
do
case $i in
    -s=*|--site=*)
    site="${i#*=}"
esac
done 
