#!/bin/bash

# Usage:
#  $ "./apache/restart.sh" -c="devel-web-server"
#  $ "./apache/restart.sh" --container="devel-web-server"

source "./argument/container.sh"

set -x # echo on

lxc exec "$container" -- sudo service apache2 restart
