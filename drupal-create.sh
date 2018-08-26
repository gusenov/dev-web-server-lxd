#!/bin/bash 

# Usage:
#  $ "./cms/drupal/create.sh" -c="devel-web-server" -s="drupal.test" -f="$HOME/Downloads/drupal-seed/site" -h="localhost" -l="root" -p="root-password-for-MySQL" -d="drupal_db" -u="drupal_db_user" -i="drupal_db_password"

source "./common/argument/container.sh"       # контейнер с Apache-сервером и доступом к MySQL-серверу.

source "./common/argument/site.sh"            # домен виртуального хоста, который нужно создать.
source "./common/argument/folder.sh"          # папка с содержимым сайта.

source "./common/argument/host.sh"            # хост на котором работает MySQL-сервер.

source "./common/argument/login.sh"           # имя пользователя, который может создавать БД и других пользователей.
source "./common/argument/password.sh"        # пароль для вышеуказанного пользователя.

source "./common/argument/database.sh"        # имя базы данных, которую нужно создать.

source "./common/argument/user.sh"            # имя MySQL-пользователя, которого нужно создать.
source "./common/argument/identification.sh"  # пароль для вышеуказанного пользователя.

set -x # echo on

"./apache/vhost/create.sh" --container="$container" \
                           --domain="$site"
                           
"./mysql/database/create.sh" --container="$container" \
                             --user="$login" \
                             --password="$password" \
                             --database="$database"

"./mysql/user/create.sh" --container="$container" \
                         --host="$host" \
                         --login="$login" \
                         --password="$password" \
                         --user="$user" \
                         --identification="$identification" \
                         --database="$database"

target_dir="/var/www/$site/public_html"

# Очистить папку для веб-содержимого:
lxc exec "$container" -- sh -c "rm -rf $target_dir/*"
lxc exec "$container" -- ls -la "$target_dir"

# Загрузить дистрибутив:
"./container/upload.sh" --container="$container" --source="$folder" --target="$target_dir"
lxc exec "$container" -- ls -la "$target_dir"

"./apache/vhost/grant.sh" --container="$container" \
                          --general="/var/www" \
                          --web="$site/public_html"

# So that the files directory can be created automatically, give the web server write privileges to the sites/default directory with the command (from the installation directory):
lxc exec "$container" -- chmod o+w "$target_dir/sites/default"

# Give the web server write privileges to the sites/default/settings.php file with the command (from the installation directory):
lxc exec "$container" -- chmod o+w "$target_dir/sites/default/settings.php"

# The install script will attempt to create a files storage directory in the default location at sites/default/files (the location of the files directory may be changed after Drupal is installed).
lxc exec "$container" -- chmod o+w "$target_dir/sites/default/files"
