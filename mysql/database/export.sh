#!/bin/bash 

# Usage:
#  $ "./mysql/database/export.sh" --container="devel-web-server" --user="" --password="" --database=""

source "./common/argument/container.sh"
source "./common/argument/user.sh"
source "./common/argument/password.sh"
source "./common/argument/database.sh"

set -x # echo on

date_time_now=$(date +"%Y%m%d_%H%M%S")

lxc exec "$container" -- mysqldump -u "$user" -p$password "$database" > "backup-$database-$date_time_now.sql"
#lxc exec "$container" -- mysqldump -u "$user" -p$password "$database" | gzip > "backup-$database-$date_time_now.sql.gz"

#lxc exec "$container" -- mysqldump -u "$user" -p$password --all-databases > "all_databases-$date_time_now.sql"

# --all-databases, -A
# 
# Dump all tables in all databases. This is the same as using the --databases option and naming all the databases on
# the command line.

# --databases, -B
#
# Dump several databases. Normally, mysqldump treats the first name argument on the command line as a database name
# and following names as table names. With this option, it treats all name arguments as database names.  CREATE
# DATABASE and USE statements are included in the output before each new database.
# 
# This option may be used to dump the INFORMATION_SCHEMA and performace_schema databases, which normally are not
# dumped even with the --all-databases option. (Also use the --skip-lock-tables option.)
