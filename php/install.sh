#!/bin/bash

# Usage:
#  $ "./php/install.sh" --container="devel-web-server" --version="7.0"
#  $ "./php/install.sh" -c="devel-web-server" -v="5"

source "./common/argument/container.sh"
source "./common/argument/version.sh"

set -x # echo on

lxc exec "$container" -- sudo apt-get -qq install php$version libapache2-mod-php$version php$version-mcrypt php$version-mysql
