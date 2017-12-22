#!/bin/bash 

# Usage:
#  $ "./apache/vhost/create.sh" --container="devel-web-server" --domain="example.com"
#  $ "./apache/vhost/create.sh" -c="devel-web-server" -d="example.com"

source "./common/argument/container.sh"
source "./common/argument/domain.sh"

set -x # echo on

apache_configuration_file="/etc/apache2/sites-available/$domain.conf"
ip=$(./container/ip.sh --container="$container")

function create_virtual_host()
{
    # Create the Directory Structure
    # The first step that we are going to take is to make a directory structure that will hold the site data that we will be serving to visitors.
    # Our document root (the top-level directory that Apache looks at to find content to serve) will be set to individual directories under the /var/www directory.
    document_root="/var/www/$domain/public_html"
    lxc exec "$container" -- sudo mkdir -p "$document_root"
    
    "./apache/vhost/grant.sh" --container="$container" \
                              --general="/var/www" \
                              --web="$domain/public_html"

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
    lxc exec "$container" -- sh -c "echo \"$index_html\" > \"$document_root/index.html\""

    lxc exec "$container" -- sudo cp "/etc/apache2/sites-available/000-default.conf" "$apache_configuration_file"


    # Apache Configuration Directives:

    # http://httpd.apache.org/docs/current/mod/core.html#servername
    # http://httpd.apache.org/docs/current/mod/core.html#serveralias
    lxc exec "$container" -- sudo sed -i "s/#ServerName www\.example\.com/ServerName $domain\n        ServerAlias www.$domain/g" "$apache_configuration_file"

    # http://httpd.apache.org/docs/current/mod/core.html#serveradmin
    lxc exec "$container" -- sudo sed -i "s/ServerAdmin webmaster@localhost/ServerAdmin webmaster@localhost/g" "$apache_configuration_file"

    # http://httpd.apache.org/docs/current/mod/core.html#documentroot
    lxc exec "$container" -- sudo sed -i "s|DocumentRoot \/var\/www\/html|DocumentRoot $document_root|g" "$apache_configuration_file"
    
    # http://httpd.apache.org/docs/current/mod/core.html#directory
    # http://httpd.apache.org/docs/current/mod/core.html#options
    # http://httpd.apache.org/docs/current/mod/core.html#allowoverride
    lxc exec "$container" -- sudo sed -i "s|</VirtualHost>|\n        <Directory $document_root>\n                Options Indexes FollowSymLinks MultiViews\n                AllowOverride All\n                Order allow,deny\n                allow from all\n        </Directory>\n</VirtualHost>|g" "$apache_configuration_file"


    lxc exec "$container" -- sudo a2ensite "$domain.conf"

    ./apache/restart.sh --container="$container"

    lxc exec "$container" -- sh -c "sudo echo \"$ip       $domain\" >> /etc/hosts"
    echo "$ip       $domain" | sudo tee --append /etc/hosts
}

action="create"
if [ "$action" == "create" ]; then
    "./apache/vhost/drop.sh" --container="$container" --domain="$domain"
    create_virtual_host
    
    lxc exec "$container" -- find "/var/www/$domain" -print | sed -e 's;/*/;|;g;s;|; |;g'
    lxc exec "$container" -- cat "$apache_configuration_file"
fi

lxc exec "$container" -- cat "/etc/hosts"


"./apache/vhost/grant.sh" --container="$container" \
                          --general="/var/www" \
                          --web="$domain/public_html"
