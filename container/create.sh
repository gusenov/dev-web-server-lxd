#!/bin/bash

# Usage:
#  $ "./container/create.sh" -c="devel-web-server"
#  $ "./container/create.sh" --container="devel-web-server"

source "./argument/container.sh"

set -x # echo on

lxc launch ubuntu: "$container"
