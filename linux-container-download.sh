#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script

container_name="devel-web-server" 
source_path=""
destination_path=""

is_directory=$(lxc exec "$container_name" -- test -d "$source_path" && echo -n true || echo -n false)
is_file=$(lxc exec "$container_name" -- test -f "$source_path" && echo -n true || echo -n false)

if [ "$is_directory" = true ] ; then
    echo "$source_path is a directory"
    mkdir -p "$destination_path"
    lxc exec "$container_name" -- tar cf - -C "$source_path" . | tar xf - -C "$destination_path"
    
elif [ "$is_file" = true ] ; then
    echo "$source_path is a file"
    lxc file pull "$container_name$source_path" "$destination_path"
    
else
    echo "$source_path is not valid"
    exit 1
fi

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
