#!/bin/bash 

# Usage:
#  $ "./apache/vhost/grant.sh" --container="devel-web-server" --general="/var/www" --web="example.com/public_html"
#  $ "./apache/vhost/grant.sh" -c="devel-web-server" -g="/var/www" -w="example.com/public_html"

source "./common/argument/container.sh"  # контейнер с веб-сервером Apache.

source "./common/argument/general.sh"    # путь к главному веб-каталогу.
source "./common/argument/web.sh"        # относительный путь к веб-каталогу сайта.

set -x # echo on

# Grant Permissions

# Now we have the directory structure for our files, but they are owned by our root user.
# If we want our regular user to be able to modify files in our web directories, we can change the ownership by doing this:
current_user=$(lxc exec "$container" -- sh -c 'echo $USER')
lxc exec "$container" -- sudo chown -R $current_user:$current_user "$general/$web"
# The $USER variable will take the value of the user you are currently logged in as when you press "ENTER". 
# By doing this, our regular user now owns the public_html subdirectories where we will be storing our content.

# We should also modify our permissions a little bit to ensure that read access is permitted to the general web directory and all of the files and folders it contains so that pages can be served correctly:
lxc exec "$container" -- sudo chmod -R 755 "$general"
# Your web server should now have the permissions it needs to serve content, and your user should be able to create content within the necessary folders.
