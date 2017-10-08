#!/bin/bash

# Usage:
#  source "./common/argument/host.sh"

host="localhost"

for i in "$@"
do
case $i in
    -h=*|--host=*)
    host="${i#*=}"
esac
done 
