#!/bin/bash

# Usage:
#  source "./common/argument/database.sh"

database=""

for i in "$@"
do
case $i in
    -d=*|--database=*)
    database="${i#*=}"
esac
done 
