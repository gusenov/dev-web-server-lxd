#!/bin/bash

# Usage:
#  source "./argument/container.sh"

container="devel-web-server"

for i in "$@"
do
case $i in
    -c=*|--container=*)
    container="${i#*=}"
    shift # past argument=value
esac
done 
