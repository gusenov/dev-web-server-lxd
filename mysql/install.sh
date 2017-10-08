#!/bin/bash

# Usage:
#  $ "./mysql/install.sh" -c="devel-web-server" -p="Enter-Your-Password-Here"
#  $ "./mysql/install.sh" --container="devel-web-server" --password="Enter-Your-Password-Here"

source "./common/argument/container.sh"
source "./common/argument/password.sh"

set -x # echo on

lxc exec "$container" -- sudo apt-get -qq install debconf-utils
lxc exec "$container" -- sudo debconf-get-selections | grep mysql

lxc exec "$container" -- sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $password"
lxc exec "$container" -- sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $password"

lxc exec "$container" -- sudo apt-get -qq install mysql-server
