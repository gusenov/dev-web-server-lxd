#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script 

container_name="devel-web-server"
mysql_user_name="root"
mysql_user_password=""
host="localhost"
database_name=""
file="data.sql"

lxc exec "$container_name" -- mysql -u "$mysql_user_name" -p$mysql_user_password -h "$host" "$database_name" < "$file"
