#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script

container_name="devel-web-server" 
source_path=""
destination_path=""

is_directory=$(test -d "$source_path" && echo -n true || echo -n false)
is_file=$(test -f "$source_path" && echo -n true || echo -n false)

if [ "$is_directory" = true ] ; then
    echo "$source_path is a directory"
    lxc exec "$container_name" -- mkdir -p "$destination_path"
    tar cf - -C "$source_path" . | lxc exec "$container_name" -- tar xf - -C "$destination_path"
    
elif [ "$is_file" = true ] ; then
    echo "$source_path is a file"
    lxc file push "$source_path" "$container_name$destination_path"
    
else
    echo "$source_path is not valid"
    exit 1
fi

# Usage:
#  Загрузить с хоста файл /etc/hosts в контейнер и сохранить его по пути /root/hosts:
#  $ "./container/upload.sh" -c="devel-web-server" -s="/etc/hosts" -t="/root/hosts"
#
#  Загрузить с хоста содержимое папки ~/Downloads в контейнер и сохранить его в папку по пути /root/Downloads:
#  $ "./container/upload.sh" -c="devel-web-server" -s="$HOME/Downloads" -t="/root/Downloads"
