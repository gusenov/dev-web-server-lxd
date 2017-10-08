#!/bin/bash

# Usage:
#  source "./common/argument/container.sh"

container="devel-web-server"

for i in "$@"
do
case $i in
    -c=*|--container=*)
    container="${i#*=}"
esac
done 
