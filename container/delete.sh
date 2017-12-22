#!/bin/bash

# Usage:
#  $ "./container/delete.sh" -c="devel-web-server"
#  $ "./container/delete.sh" --container="devel-web-server"

source "./common/argument/container.sh"

set -x # echo on

./container/stop.sh --container="$container"

"./common/output/colorful.sh" --colour="red" --format="b" \
                              --text="Removing container $container..." 
lxc delete "$container"
