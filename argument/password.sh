#!/bin/bash

# Usage:
#  source "./argument/password.sh"

password=""

for i in "$@"
do
case $i in
    -p=*|--password=*)
    password="${i#*=}"
    shift # past argument=value
esac
done 
