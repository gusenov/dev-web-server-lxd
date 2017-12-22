#!/bin/bash 

# Usage:
#  $ "./mysql/database/drop.sh" --container="devel-web-server" --user="root" --password="Enter-Your-Password-Here" --database=""

source "./common/argument/container.sh"
source "./common/argument/user.sh"
source "./common/argument/password.sh"
source "./common/argument/database.sh"

"./common/output/colorful.sh" --colour="red" --format="b" \
                              --text="Dropping MySQL database $database..." 

set -x # echo on

(
cat <<EOF

show databases;

DROP DATABASE IF EXISTS \`$database\`;

show databases;

EOF
) | lxc exec "$container" -- mysql -u $user -p$password -v
