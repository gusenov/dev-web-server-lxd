#!/bin/bash 

# Usage:
#  $ "./mysql/database/create.sh" --container="devel-web-server" --user="root" --password="Enter-Your-Password-Here" --host="localhost" --database=""

source "./common/argument/container.sh"
source "./common/argument/user.sh"
source "./common/argument/password.sh"
source "./common/argument/host.sh"
source "./common/argument/database.sh"

set -x # echo on

lxc exec "$container" -- mysql -u "$user" -p$password -h "$host" "$database" < data.sql
