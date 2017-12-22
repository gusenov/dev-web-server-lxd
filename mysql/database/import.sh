#!/bin/bash 

# Usage:
#  $ "./mysql/database/import.sh" --container="devel-web-server" --user="root" --password="Enter-Your-Password-Here" --host="localhost" --database="" --file="data.sql"

source "./common/argument/container.sh"
source "./common/argument/user.sh"
source "./common/argument/password.sh"
source "./common/argument/host.sh"
source "./common/argument/database.sh"
source "./common/argument/file.sh"

set -x # echo on

lxc exec "$container" -- mysql -u "$user" -p$password -h "$host" "$database" < "$file"
