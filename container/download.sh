#!/bin/bash 

# Usage:
#  Скачать с контейнера файл /etc/hosts и сохранить его по пути ./hosts:
#  $ "./container/download.sh" -c="devel-web-server" -s="/etc/hosts" -t="./hosts"
#
#  Скачать с контейнера файл /etc/hosts в текущую папку хосте:
#  $ "./container/download.sh" -c="devel-web-server" -s="/etc/hosts" -t="."
#
#  Скачать с контейнера содержимое папки/var/www/html в текущую папку на хосте:
#  $ "./container/download.sh" -c="devel-web-server" -s="/var/www/html" -t="."
#
#  Скачать с контейнера содержимое папки/var/www/html и сохранить его в папку по пути ./html:
#  $ "./container/download.sh" -c="devel-web-server" -s="/var/www/html" -t="./html"

source "./common/argument/container.sh"
source "./common/argument/source.sh"
source "./common/argument/target.sh"

set -x # echo on

is_directory=$(lxc exec "$container" -- test -d "$source" && echo -n true || echo -n false)
is_file=$(lxc exec "$container" -- test -f "$source" && echo -n true || echo -n false)

if [ "$is_directory" = true ] ; then
    echo "$source is a directory"
    mkdir -p "$target"
    lxc exec "$container" -- tar cf - -C "$source" . | tar xf - -C "$target"
    
elif [ "$is_file" = true ] ; then
    echo "$source is a file"
    lxc file pull "$container$source" "$target"
    
else
    echo "$source is not valid"
    exit 1
fi
