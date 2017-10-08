#!/bin/bash

# Usage:
#  source "./common/argument/domain.sh"

domain="example.com"

for i in "$@"
do
case $i in
    -d=*|--domain=*)
    domain="${i#*=}"
esac
done 
