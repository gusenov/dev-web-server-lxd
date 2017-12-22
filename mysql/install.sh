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

# Allow Remote MySQL Database Connection
# You should actually comment out that line entirely, then it will listen on all IPs and ports which you need because you will be connecting remotely to it over public IPv4.
lxc exec "$container" -- sudo sed -i "s/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/g" "/etc/mysql/my.cnf"
lxc exec "$container" -- sudo service mysql restart

lxc exec "$container" -- sudo apt-get -qq install mysql-utilities
