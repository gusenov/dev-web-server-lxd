#!/bin/bash

# Usage:
#  $ "./container/ip.sh" -c="devel-web-server" -i="eth0"
#  $ "./container/ip.sh" --container="devel-web-server" --interface="eth0"

source "./common/argument/container.sh"
source "./common/argument/interface.sh"

set -x # echo on

lxc exec "$container" -- /sbin/ifconfig "$interface" | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }'

# lxc list | grep "$container" | awk '{print $6}'
