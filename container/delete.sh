#!/bin/bash

# Usage:
#  $ "./container/delete.sh" -c="devel-web-server"
#  $ "./container/delete.sh" --container="devel-web-server"

source "./argument/container.sh"

set -x # echo on

./container/stop.sh --container="$container"
lxc delete "$container"
