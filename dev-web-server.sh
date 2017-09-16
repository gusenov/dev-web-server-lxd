#!/bin/bash

# Usage:
#  $ "./dev-web-server.sh" -c="devel-web-server" -u="root" -p="Enter-Your-Password-Here"
#  $ "./dev-web-server.sh" --container="devel-web-server" --user="root" --password="Enter-Your-Password-Here"

set -x # echo on

source "./argument/container.sh"
source "./argument/user.sh"
source "./argument/password.sh"

./container/delete.sh --container="$container"
./container/create.sh --container="$container"

sleep 16

echo -n "Your server’s IP address: "
./container/ip.sh     --container="$container"

./container/update.sh --container="$container"
./apache/install.sh   --container="$container"
./php/install.sh      --container="$container"
./mysql/install.sh    --container="$container" --password="$password"
./mysql/secure.sh     --container="$container" --user="$user" --password="$password"
./apache/restart.sh   --container="$container"


# Информация о контейнере:
# lxc list
# lxc info "$container_name"
# lxc config show --expanded "$container_name"
# lxc config get "$container_name" security.privileged
# lxc list | grep "$container_name" | awk '{print $6}' # IP
# cat /etc/default/lxd-bridge

# Чтобы просмотреть другие доступные опции нужно выполнить:
# sudo apt-get -qq install debconf-utils
# sudo debconf-get-selections | grep mysql


