#!/bin/bash 

# Usage:
#  $ "./apache/vhost/drop.sh" --container="devel-web-server" --domain="example.com"
#  $ "./apache/vhost/drop.sh" -c="devel-web-server" -d="example.com"

source "./common/argument/container.sh"
source "./common/argument/domain.sh"

set -x # echo on

lxc exec "$container" -- sudo a2dissite "$domain.conf"
lxc exec "$container" -- sudo rm "/etc/apache2/sites-available/$domain.conf"
lxc exec "$container" -- rm -rf "/var/www/$domain"

./apache/restart.sh --container="$container"

lxc exec "$container" -- sudo sed -i '/'"$domain"'/d' "/etc/hosts"
sudo sed -i '/'"$domain"'/d' "/etc/hosts"

lxc exec "$container" -- ls -la "/var/www"
lxc exec "$container" -- ls -la "/etc/apache2/sites-available"

lxc exec "$container" -- cat "/etc/hosts"
