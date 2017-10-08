#!/bin/bash

# Usage:
#  source "./common/argument/password.sh"

password="Enter-Your-Password-Here"

for i in "$@"
do
case $i in
    -p=*|--password=*)
    password="${i#*=}"
esac
done 
