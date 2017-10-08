#!/bin/bash

# Usage:
#  $ "./container/info.sh" -c="devel-web-server"
#  $ "./container/info.sh" --container="devel-web-server"

source "./common/argument/container.sh"

set -x # echo on

cat /etc/default/lxd-bridge

lxc config get "$container" security.privileged
lxc config show --expanded "$container"
lxc info "$container"
