#!/bin/bash

# Usage:
#  source "./common/argument/login.sh"

login=""

for i in "$@"
do
case $i in
    -l=*|--login=*)
    login="${i#*=}"
esac
done 
