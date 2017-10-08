#!/bin/bash 

# Usage:
#  $ "./mysql/user/create.sh" --container="devel-web-server" --host="localhost" --login="root" --password="Enter-Your-Password-Here" --user="" --identification="password" --database=""

source "./common/argument/container.sh"

source "./common/argument/host.sh"

source "./common/argument/login.sh"
source "./common/argument/password.sh"

source "./common/argument/user.sh"
source "./common/argument/identification.sh"

source "./common/argument/database.sh"

set -x # echo on

(
cat <<EOF

SELECT user FROM mysql.user GROUP BY user;

CREATE USER '$user'@'$host' IDENTIFIED BY '$identification';

-- Sadly, at this point newuser has no permissions to do anything with the databases.
-- In fact, if newuser even tries to login (with the password, password), they will not be able to reach the MySQL shell.
-- Therefore, the first thing to do is to provide the user with access to the information they will need.

SELECT user FROM mysql.user GROUP BY user;

SHOW GRANTS FOR '$user'@'$host';

-- GRANT ALL PRIVILEGES ON *.* TO '$user'@'$host';

-- The asterisks in this command refer to the database and table (respectively) that they can access—this specific command allows to the user to read, edit, execute and perform all tasks across all the databases and tables.
-- Once you have finalized the permissions that you want to set up for your new users, always be sure to reload all the privileges.

GRANT ALL PRIVILEGES ON \`$database\`.* TO '$user'@'$host';
FLUSH PRIVILEGES;

SHOW GRANTS FOR '$user'@'$host';

EOF
) | lxc exec "$container" -- mysql -u $login -p$password -v
