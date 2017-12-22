#!/bin/bash

# Usage:
#  $ "./container/stop.sh" -c="devel-web-server"
#  $ "./container/stop.sh" --container="devel-web-server"

source "./common/argument/container.sh"

"./common/output/colorful.sh" --colour="red" --format="b" \
                              --text="Stopping container $container..." 

set -x # echo on

lxc stop "$container"
