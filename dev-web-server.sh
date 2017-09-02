#!/bin/bash
set -x # echo on

# Usage:
#  $ ./dev-web-server.sh -n=devel-web-server
#  $ ./dev-web-server.sh --name=devel-web-server

# Наименование по умолчанию для LXC-контейнера для веб-разработки:
container_name="devel-web-server"

for i in "$@"
do
case $i in
    -n=*|--name=*)
    container_name="${i#*=}"
    shift # past argument=value
    ;;
esac
done


function update_container()
{
    lxc exec "$1" -- sudo apt-get update
    lxc exec "$1" -- sudo apt-get -qq upgrade
    lxc exec "$1" -- sudo apt-get autoremove
}

function install_apache_mysql_and_php()
{
    # lxc exec "$1" -- ifconfig eth0 | grep inet | awk '{ print $2 }' # your Server’s IP address
    
    # Установка Apache HTTP Server:
    lxc exec "$1" -- sudo apt-get -qq install apache2

    # Установка MySQL Server:
    lxc exec "$1" -- sudo apt-get -qq install mysql-server php7.0-mysql
    lxc exec "$1" -- sudo /usr/bin/mysql_secure_installation
    
    # Установка PHP:
    lxc exec "$1" -- sudo apt-get -qq install php7.0 libapache2-mod-php7.0 php7.0-mcrypt
    
    # Перезапуск веб-сервера:
    lxc exec "$1" -- sudo service apache2 restart
}

# Остановить и удалить старый контейнер:
lxc stop "$container_name"
lxc delete "$container_name"

# Создать и запустить новый контейнер:
lxc launch ubuntu: "$container_name"

# Информация о контейнере:
# lxc list
# lxc info "$container_name"
# lxc config show --expanded "$container_name"
# lxc config get "$container_name" security.privileged
# lxc list | grep "$container_name" | awk '{print $6}' # IP
# cat /etc/default/lxd-bridge

# Нужно немного подождать пока всё запустится:
sleep 16

update_container "$container_name"
install_apache_mysql_and_php "$container_name"
