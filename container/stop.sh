#!/bin/bash

# Usage:
#  $ "./container/stop.sh" -c="devel-web-server"
#  $ "./container/stop.sh" --container="devel-web-server"

source "./common/argument/container.sh"

set -x # echo on

lxc stop "$container"
