#!/bin/bash

# Usage:
#  source "./common/argument/interface.sh"

interface="eth0"

for i in "$@"
do
case $i in
    -i=*|--interface=*)
    interface="${i#*=}"
esac
done 
