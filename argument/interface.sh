#!/bin/bash

# Usage:
#  source "./argument/interface.sh"

interface="eth0"

for i in "$@"
do
case $i in
    -i=*|--interface=*)
    interface="${i#*=}"
    shift # past argument=value
esac
done 
