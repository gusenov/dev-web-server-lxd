#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script

container_name="devel-web-server"
domain="example.com"

#---------------------------------------------------------------------------

# Create the Directory Structure
# The first step that we are going to take is to make a directory structure that will hold the site data that we will be serving to visitors.
# Our document root (the top-level directory that Apache looks at to find content to serve) will be set to individual directories under the /var/www directory.
document_root="/var/www/$domain/public_html"
lxc exec "$container_name" -- sudo mkdir -p "$document_root"

#---------------------------------------------------------------------------

# Grant Permissions

# Now we have the directory structure for our files, but they are owned by our root user.
# If we want our regular user to be able to modify files in our web directories, we can change the ownership by doing this:
current_user=$(lxc exec "$container_name" -- sh -c 'echo $USER')  # The $USER variable will take the value of the user you are currently logged in as when you press "ENTER". 
lxc exec "$container_name" -- sudo chown -R $current_user:$current_user "$document_root"  # By doing this, our regular user now owns the public_html subdirectories where we will be storing our content.

# We should also modify our permissions a little bit to ensure that read access is permitted to the general web directory and all of the files and folders it contains so that pages can be served correctly:
lxc exec "$container_name" -- sudo chmod -R 755 "/var/www"
# Your web server should now have the permissions it needs to serve content, and your user should be able to create content within the necessary folders.

#---------------------------------------------------------------------------

index_html=$(cat << EOF
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Welcome to $domain!</title>
    </head>
    <body>
        <h1>Success! The $domain virtual host is working!</h1>
    </body>
</html>
EOF
)
lxc exec "$container_name" -- sh -c "echo \"$index_html\" > \"$document_root/index.html\""

#lxc exec "$container_name" -- find "/var/www/$domain" -print | sed -e 's;/*/;|;g;s;|; |;g'

#---------------------------------------------------------------------------

apache_configuration_file="/etc/apache2/sites-available/$domain.conf"
lxc exec "$container_name" -- sudo cp "/etc/apache2/sites-available/000-default.conf" "$apache_configuration_file"

# Apache Configuration Directives:

# http://httpd.apache.org/docs/current/mod/core.html#servername
# http://httpd.apache.org/docs/current/mod/core.html#serveralias
lxc exec "$container_name" -- sudo sed -i "s/#ServerName www\.example\.com/ServerName $domain\n        ServerAlias www.$domain/g" "$apache_configuration_file"

# http://httpd.apache.org/docs/current/mod/core.html#serveradmin
lxc exec "$container_name" -- sudo sed -i "s/ServerAdmin webmaster@localhost/ServerAdmin webmaster@localhost/g" "$apache_configuration_file"

# http://httpd.apache.org/docs/current/mod/core.html#documentroot
lxc exec "$container_name" -- sudo sed -i "s|DocumentRoot \/var\/www\/html|DocumentRoot $document_root|g" "$apache_configuration_file"

# http://httpd.apache.org/docs/current/mod/core.html#directory
# http://httpd.apache.org/docs/current/mod/core.html#options
# http://httpd.apache.org/docs/current/mod/core.html#allowoverride
lxc exec "$container_name" -- sudo sed -i "s|</VirtualHost>|\n        <Directory $document_root>\n                Options Indexes FollowSymLinks MultiViews\n                AllowOverride All\n                Order allow,deny\n                allow from all\n        </Directory>\n</VirtualHost>|g" "$apache_configuration_file"

#lxc exec "$container_name" -- cat "$apache_configuration_file"

lxc exec "$container_name" -- sudo a2ensite "$domain.conf"
lxc exec "$container_name" -- sudo service apache2 reload  # remain running + re-read configuration files

#---------------------------------------------------------------------------

container_ip=$(lxc list | grep "$container_name" | awk '{print $6}')
lxc exec "$container_name" -- sh -c "sudo echo \"$container_ip       $domain\" >> /etc/hosts"
echo "$container_ip       $domain" | sudo tee --append /etc/hosts
#lxc exec "$container_name" -- cat "/etc/hosts"

#---------------------------------------------------------------------------
