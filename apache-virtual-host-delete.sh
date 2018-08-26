#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script

container_name="devel-web-server"
domain="example.com"

#---------------------------------------------------------------------------

lxc exec "$container_name" -- sudo a2dissite "$domain.conf"
lxc exec "$container_name" -- sudo rm "/etc/apache2/sites-available/$domain.conf"
#lxc exec "$container_name" -- ls -la "/etc/apache2/sites-available"
lxc exec "$container_name" -- rm -rf "/var/www/$domain"
#lxc exec "$container_name" -- ls -la "/var/www"
lxc exec "$container_name" -- sudo service apache2 reload  # remain running + re-read configuration files

#---------------------------------------------------------------------------

lxc exec "$container_name" -- sudo sed -i '/'"$domain"'/d' "/etc/hosts"
sudo sed -i '/'"$domain"'/d' "/etc/hosts"
#lxc exec "$container_name" -- cat "/etc/hosts"

#---------------------------------------------------------------------------
