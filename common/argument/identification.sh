#!/bin/bash

# Usage:
#  source "./common/argument/identification.sh"

identification="password"

for i in "$@"
do
case $i in
    -i=*|--identification=*)
    identification="${i#*=}"
esac
done 
