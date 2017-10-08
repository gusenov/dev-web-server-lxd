#!/bin/bash

# Usage:
#  $ "./apache/install.sh" -c="devel-web-server"
#  $ "./apache/install.sh" --container="devel-web-server"

source "./common/argument/container.sh"

set -x # echo on

lxc exec "$container" -- sudo apt-get -qq install apache2
