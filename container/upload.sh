#!/bin/bash 

# Usage:
#  Загрузить с хоста файл /etc/hosts в контейнер и сохранить его по пути /root/hosts:
#  $ "./container/upload.sh" -c="devel-web-server" -s="/etc/hosts" -t="/root/hosts"
#
#  Загрузить с хоста содержимое папки ~/Downloads в контейнер и сохранить его в папку по пути /root/Downloads:
#  $ "./container/upload.sh" -c="devel-web-server" -s="$HOME/Downloads" -t="/root/Downloads"

source "./common/argument/container.sh"
source "./common/argument/source.sh"
source "./common/argument/target.sh"

set -x # echo on

is_directory=$(test -d "$source" && echo -n true || echo -n false)
is_file=$(test -f "$source" && echo -n true || echo -n false)

if [ "$is_directory" = true ] ; then
    echo "$source is a directory"
    lxc exec "$container" -- mkdir -p "$target"
    tar cf - -C "$source" . | lxc exec "$container" -- tar xf - -C "$target"
    
elif [ "$is_file" = true ] ; then
    echo "$source is a file"
    lxc file push "$source" "$container$target"
    
else
    echo "$source is not valid"
    exit 1
fi
