#!/bin/bash

# Usage:
#  $ "./container/update.sh" -c="devel-web-server"
#  $ "./container/update.sh" --container="devel-web-server"

source "./common/argument/container.sh"

set -x # echo on

lxc exec "$container" -- sudo apt-get -qq update
lxc exec "$container" -- sudo apt-get -qq upgrade
lxc exec "$container" -- sudo apt-get -qq autoremove
