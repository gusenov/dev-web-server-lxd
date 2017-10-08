#!/bin/bash

# Usage:
#  source "./common/argument/user.sh"

user="root"

for i in "$@"
do
case $i in
    -u=*|--user=*)
    user="${i#*=}"
esac
done 
