#!/bin/bash

# Usage:
#  source "./common/argument/colour.sh"

colour="green"

for i in "$@"
do
case $i in
    -c=*|--colour=*)
    colour="${i#*=}"
esac
done 
