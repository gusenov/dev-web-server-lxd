#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script

container_name="devel-web-server"
database_name=""
mysql_user_name="root"
mysql_user_password=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
host="localhost"
mysql_new_user_name=""
mysql_new_user_password=""

(
cat <<EOF

SELECT user FROM mysql.user GROUP BY user;

CREATE USER '$mysql_new_user_name'@'$host' IDENTIFIED BY '$mysql_new_user_password';

-- Sadly, at this point newuser has no permissions to do anything with the databases.
-- In fact, if newuser even tries to login (with the password, password), they will not be able to reach the MySQL shell.
-- Therefore, the first thing to do is to provide the user with access to the information they will need.

SELECT user FROM mysql.user GROUP BY user;

SHOW GRANTS FOR '$mysql_new_user_name'@'$host';

-- GRANT ALL PRIVILEGES ON *.* TO '$mysql_new_user_name'@'$host';

-- The asterisks in this command refer to the database and table (respectively) that they can access—this specific command allows to the user to read, edit, execute and perform all tasks across all the databases and tables.
-- Once you have finalized the permissions that you want to set up for your new users, always be sure to reload all the privileges.

-- GRANT ALL PRIVILEGES ON \`$database_name\`.* TO '$mysql_new_user_name'@'$host';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON \`$database_name\`.* TO '$mysql_new_user_name'@'$host';
FLUSH PRIVILEGES;

SHOW GRANTS FOR '$mysql_new_user_name'@'$host';

EOF
) | lxc exec "$container_name" -- mysql -u $mysql_user_name -p$mysql_user_password -v

echo "Your MySQL User Password is: $mysql_user_password"
