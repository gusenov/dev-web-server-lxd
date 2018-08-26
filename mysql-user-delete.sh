#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script

container_name="devel-web-server"
mysql_user_name="root"
mysql_user_password=""
host="localhost"
mysql_target_user_name=""


(
cat <<EOF

SELECT user FROM mysql.user GROUP BY user;

-- This creates the user if it doesn't already exist (and grants it a harmless privilege).
GRANT USAGE ON *.* TO '$mysql_target_user_name'@'$host';

DROP USER '$mysql_target_user_name'@'$host';

-- You can simply delete the user from the mysql.user table (which doesn't throw an error if the user does not exist), and then flush privileges to apply the change.
DELETE FROM mysql.user WHERE User = '$mysql_target_user_name' AND Host = '$host';
FLUSH PRIVILEGES;

SELECT user FROM mysql.user GROUP BY user;

EOF
) | lxc exec "$container_name" -- mysql -u $mysql_user_name -p$mysql_user_password -v
