#!/bin/bash

# Usage:
#  $ "./apache/reload.sh" -c="devel-web-server"
#  $ "./apache/reload.sh" --container="devel-web-server"

source "./common/argument/container.sh"

set -x # echo on

lxc exec "$container" -- sudo service apache2 reload
