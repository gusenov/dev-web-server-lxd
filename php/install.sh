#!/bin/bash

# Usage:
#  $ "./php/install.sh" -c="devel-web-server"
#  $ "./php/install.sh" --container="devel-web-server"

source "./argument/container.sh"

set -x # echo on

lxc exec "$container" -- sudo apt-get -qq install php7.0 libapache2-mod-php7.0 php7.0-mcrypt
