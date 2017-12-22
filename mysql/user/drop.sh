#!/bin/bash 

# Usage:
#  $ "./mysql/user/drop.sh" --container="devel-web-server" --host="localhost" --login="root" --password="Enter-Your-Password-Here" --user=""

source "./common/argument/container.sh"

source "./common/argument/host.sh"

source "./common/argument/user.sh"
source "./common/argument/password.sh"

source "./common/argument/login.sh"

"./common/output/colorful.sh" --colour="red" --format="b" \
                              --text="Dropping MySQL user $user..." 

set -x # echo on

(
cat <<EOF

SELECT user FROM mysql.user GROUP BY user;

-- This creates the user if it doesn't already exist (and grants it a harmless privilege).
GRANT USAGE ON *.* TO '$user'@'$host';

DROP USER '$user'@'$host';

-- You can simply delete the user from the mysql.user table (which doesn't throw an error if the user does not exist), and then flush privileges to apply the change.
DELETE FROM mysql.user WHERE User = '$user' AND Host = '$host';
FLUSH PRIVILEGES;

SELECT user FROM mysql.user GROUP BY user;

EOF
) | lxc exec "$container" -- mysql -u $login -p$password -v
