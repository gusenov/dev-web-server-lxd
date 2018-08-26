#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script

container_name="devel-web-server"
database_name=""
mysql_user_name="root"
mysql_user_password=""

(
cat <<EOF

show databases;

DROP DATABASE IF EXISTS \`$database_name\`;

show databases;

EOF
) | lxc exec "$container_name" -- mysql -u $mysql_user_name -p$mysql_user_password -v
