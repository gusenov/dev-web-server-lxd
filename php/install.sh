#!/bin/bash

# Usage:
#  $ "./php/install.sh" --container="devel-web-server" --version="7.0"
#  $ "./php/install.sh" -c="devel-web-server" -v="5"

source "./common/argument/container.sh"
source "./common/argument/version.sh"

set -x # echo on

lxc exec "$container" -- sudo apt-get -qq install php$version libapache2-mod-php$version php$version-mcrypt php$version-mysql

# PHP also has a variety of useful libraries and modules that you can add onto your virtual server.
# You can see the libraries that are available.
# Terminal will then display the list of possible modules. The beginning looks like this:
apt-cache search php$version-

# Once you decide to install the module, type:
lxc exec "$container" -- sudo apt-get -qq install php$version-gd

# You can install multiple libraries at once by separating the name of each module with a space.
