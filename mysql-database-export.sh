#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script 

container_name="devel-web-server"
mysql_user_name="root"
mysql_user_password=""
database_name=""

date_time_now=$(date +"%Y%m%d_%H%M%S")

lxc exec "$container_name" -- mysqldump -u "$mysql_user_name" -p$mysql_user_password "$database_name" > "backup-$database_name-$date_time_now.sql"
lxc exec "$container_name" -- mysqldump -u "$mysql_user_name" -p$mysql_user_password "$database_name" | gzip > "backup-$database_name-$date_time_now.sql.gz"

lxc exec "$container_name" -- mysqldump -u "$mysql_user_name" -p$mysql_user_password --all-databases > "all_databases-$date_time_now.sql"

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

