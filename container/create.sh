#!/bin/bash

# Usage:
#  $ "./container/create.sh" --container="devel-web-server" --version="16.04"
#  $ "./container/create.sh" -c="devel-web-server" -v="14.04"

source "./common/argument/container.sh"
source "./common/argument/version.sh"

set -x # echo on

lxc launch ubuntu:$version "$container"
