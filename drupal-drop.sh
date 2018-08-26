#!/bin/bash 

# Usage:
#  $ "./cms/drupal/drop.sh" -c="devel-web-server" -s="drupal.test" -h="localhost" -l="root" -p="root-password-for-MySQL" -u="drupal_db_user" -d="drupal_db"

source "./common/argument/container.sh"  # контейнер с Apache-сервером и доступом к MySQL-серверу.

source "./common/argument/site.sh"       # домен виртуального хоста, который нужно удалить.

source "./common/argument/host.sh"       # хост на котором работает MySQL-сервер.

source "./common/argument/login.sh"      # имя пользователя, который может удалять БД и других пользователей.
source "./common/argument/password.sh"   # пароль для вышеуказанного пользователя.

source "./common/argument/user.sh"       # имя MySQL-пользователя, которого нужно удалить.

source "./common/argument/database.sh"   # имя базы данных, которую нужно удалить.

"./common/output/colorful.sh" --colour="red" --format="b" \
                              --text="Deleting Drupal site $site..." 

set -x # echo on

"./apache/vhost/drop.sh" --container="$container" \
                         --domain="$site"

"./mysql/user/drop.sh" --container="$container" \
                       --host="$host" \
                       --login="$login" --password="$password" \
                       --user="$user"

"./mysql/database/drop.sh" --container="$container" \
                           --user="$login" --password="$password" \
                           --database="$database"
