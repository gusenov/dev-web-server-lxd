#!/bin/bash 

# Usage:
#  $ "./cms/drupal/secure.sh" -c="devel-web-server" -s="drupal.test"

source "./common/argument/container.sh"       # контейнер с Apache-сервером.

source "./common/argument/site.sh"            # домен виртуального хоста на котором расположен сайт.

set -x # echo on

target_dir="/var/www/$site/public_html"

lxc exec "$container" -- chmod a-w "$target_dir/sites/default"

lxc exec "$container" -- chmod a-w "$target_dir/sites/default/settings.php"

# Hide documentation files from public view:
lxc exec "$container" -- chmod a-r "$target_dir/CHANGELOG.txt"
