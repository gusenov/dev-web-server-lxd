#!/bin/bash

# Usage:
#  source "./argument/user.sh"

user="root"

for i in "$@"
do
case $i in
    -u=*|--user=*)
    user="${i#*=}"
    shift # past argument=value
esac
done 
