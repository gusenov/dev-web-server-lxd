#!/bin/bash

# Usage:
#  $ "./apache/install.sh" -c="devel-web-server"
#  $ "./apache/install.sh" --container="devel-web-server"

source "./common/argument/container.sh"

set -x # echo on

lxc exec "$container" -- sudo apt-get -qq install apache2

# Enabling mod_rewrite
# Now, we need to activate mod_rewrite.
lxc exec "$container" -- sudo a2enmod rewrite
# This will activate the module or alert you that the module is already in effect.
# To put these changes into effect, restart Apache.
"./apache/restart.sh" --container="$container"
