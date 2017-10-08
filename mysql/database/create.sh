#!/bin/bash 

# Usage:
#  $ "./mysql/database/create.sh" --container="devel-web-server" --user="root" --password="Enter-Your-Password-Here" --database=""

source "./common/argument/container.sh"
source "./common/argument/user.sh"
source "./common/argument/password.sh"
source "./common/argument/database.sh"

set -x # echo on

(
cat <<EOF

show databases;

CREATE DATABASE IF NOT EXISTS \`$database\`;

show databases;

EOF
) | lxc exec "$container" -- mysql -u $user -p$password -v
