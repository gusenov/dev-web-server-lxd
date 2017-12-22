#!/bin/bash

# Usage:
#  $ "./create.sh" --container="devel-web-server" --version="trusty" --user="root" --password="root-password-for-MySQL"
#  $ "./create.sh" -c="devel-web-server" -v="trusty" -u="root" -p="root-password-for-MySQL"

source "./common/argument/container.sh"  # имя для нового контейнера.

source "./common/argument/version.sh"    # версия Ubuntu.

source "./common/argument/user.sh"       # имя суперпользователя MySQL.
source "./common/argument/password.sh"   # пароль для вышеуказанного суперпользователя.

set -x # echo on

################################################################################################################################

# Устанавливать лучше LTS-версии. Их можно посмотреть здесь: https://packages.ubuntu.com/
#  - trusty (14.04LTS)
#  - xenial (16.04LTS)

if [ "$version" == "trusty" ]; then
    ubuntu_version="14.04"
elif [ "$version" == "xenial" ]; then
    ubuntu_version="16.04"
fi

################################################################################################################################

"./container/delete.sh" --container="$container"

"./common/output/colorful.sh" --colour="magenta" --format="b" \
                              --text="Создание нового контейнера на базе Ubuntu $ubuntu_version..." 
"./container/create.sh" --container="$container" \
                        --version="$ubuntu_version"

"./common/output/colorful.sh" --colour="magenta" --format="b" \
                              --text="Information about your container:" 
"./container/info.sh"   --container="$container"

sleep 16

"./common/output/colorful.sh" --colour="magenta" --format="b" \
                              --text="Your server’s IP address:" 
"./container/ip.sh"     --container="$container"

"./common/output/colorful.sh" --colour="magenta" --format="b" \
                              --text="Обновление ОС в контейнере..." 
"./container/update.sh" --container="$container"

################################################################################################################################

"./common/output/colorful.sh" --colour="magenta" --format="b" \
                              --text="Installing Apache on Ubuntu $ubuntu_version..." 
"./apache/install.sh" --container="$container"

################################################################################################################################

"./common/output/colorful.sh" --colour="magenta" --format="b" \
                              --text="Installing MySQL Server on Ubuntu $ubuntu_version..." 
"./mysql/install.sh" --container="$container" \
                     --password="$password"

"./common/output/colorful.sh" --colour="magenta" --format="b" \
                              --text="Securing MySQL Server on Ubuntu $ubuntu_version..." 
"./mysql/secure.sh" --container="$container" \
                    --user="$user" --password="$password"

################################################################################################################################

case "$ubuntu_version" in
  "14.04") php_version="5" ;;
  "16.04") php_version="7.0" ;;
esac

"./common/output/colorful.sh" --colour="magenta" --format="b" \
                              --text="Installing PHP $php_version on Ubuntu $ubuntu_version..." 
"./php/install.sh" --container="$container" \
                              --version="$php_version"

################################################################################################################################

"./apache/restart.sh" --container="$container"

################################################################################################################################
