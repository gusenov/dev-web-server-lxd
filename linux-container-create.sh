#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script

container_name="devel-web-server"

# https://packages.ubuntu.com/
#ubuntu_version="14.04"  # trusty (14.04LTS)
ubuntu_version="16.04"  # xenial (16.04LTS)

#force_yes="--force-yes"
force_yes="--allow-downgrades --allow-remove-essential --allow-change-held-packages"
apt="sudo DEBIAN_FRONTEND=noninteractive apt-get -qq $force_yes"

#---------------------------------------------------------------------------

lxc launch "ubuntu":$ubuntu_version "$container_name"
echo "✓ Created and started the container with '$container_name' as the name and 'ubuntu:$ubuntu_version' as the OS."

sleep 16

interface_name="eth0"
container_ip=$(lxc exec "$container_name" -- /sbin/ifconfig "$interface_name" | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1 }')
echo "🛈 The container's IP is $container_ip."

#cat /etc/default/lxd-bridge
#lxc config get "$container_name" security.privileged
#lxc config show --expanded "$container_name"
#lxc info "$container_name"

lxc exec "$container_name" -- $apt update > /dev/null
lxc exec "$container_name" -- $apt upgrade > /dev/null
lxc exec "$container_name" -- $apt autoremove > /dev/null

echo "✓ The container's OS is updated."

#---------------------------------------------------------------------------

echo "⌚ Installing the Apache HTTP Server…"
lxc exec "$container_name" -- $apt install apache2 > /dev/null

# Enabling mod_rewrite
# Now, we need to activate mod_rewrite.
lxc exec "$container_name" -- sudo a2enmod --quiet rewrite
# This will activate the module or alert you that the module is already in effect.
# To put these changes into effect, restart Apache.
lxc exec "$container_name" -- sudo service apache2 restart

echo "✓ Apache installation is finished."

#---------------------------------------------------------------------------

case "$ubuntu_version" in
    "14.04") php_version="5" ;;
    "16.04") php_version="7.0" ;;
esac

echo "⌚ Installing PHP $php_version…"
lxc exec "$container_name" -- $apt install php$php_version libapache2-mod-php$php_version php$php_version-mcrypt php$php_version-mysql > /dev/null

# PHP also has a variety of useful libraries and modules that you can add onto your virtual server.
# You can see the libraries that are available.
# Terminal will then display the list of possible modules. The beginning looks like this:
#apt-cache search php$php_version-

# Once you decide to install the module, type:
lxc exec "$container_name" -- $apt install php$php_version-gd > /dev/null
# You can install multiple libraries at once by separating the name of each module with a space.

echo "✓ PHP $php_version installation is finished."

#---------------------------------------------------------------------------

#lxc exec "$container_name" -- $apt install debconf-utils > /dev/null
#lxc exec "$container_name" -- sudo debconf-get-selections | grep mysql

mysql_root_password=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
lxc exec "$container_name" -- sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password"
lxc exec "$container_name" -- sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_root_password"

echo "⌚ Installing the MySQL server…"
lxc exec "$container_name" -- $apt install mysql-server mysql-utilities > /dev/null

# Allow Remote MySQL Database Connection
# You should actually comment out that line entirely, then it will listen on all IPs and ports which you need because you will be connecting remotely to it over public IPv4.
lxc exec "$container_name" -- sudo sed -i "s/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/g" "/etc/mysql/my.cnf"
lxc exec "$container_name" -- sudo service mysql restart

#=== MySQL Secure Installation ===

if lxc exec "$container_name" -- echo "SHOW VARIABLES LIKE 'validate_password_policy';" \
    | lxc exec "$container_name" -- MYSQL_PWD=$mysql_root_password mysql -u root -N \
        | grep --silent validate_password_policy; then
    validate_password_plugin=1
else
    validate_password_plugin=0
fi

# install expect if needed:
if [ `lxc exec "$container_name" -- which expect` ]; then
    expect_already_installed=1
else
    echo "⌚ Installing the expect utility…"
    expect_already_installed=0
    lxc exec "$container_name" -- $apt update > /dev/null
    lxc exec "$container_name" -- $apt install expect > /dev/null
    echo "✓ Expect installation is finished."
fi

if [ "$ubuntu_version" == "14.04" ]; then

lxc exec "$container_name" -- expect -f - <<-EOF
    set timeout 10
    spawn mysql_secure_installation
    
    expect "Enter current password for root (enter for none):"
    send -- "$mysql_root_password\r"
    
    expect "Change the root password? \[Y/n\]"
    send -- "n\r"
    
    expect "Remove anonymous users? \[Y/n\]"
    send -- "Y\r"
    
    expect "Disallow root login remotely? \[Y/n\]"
    send -- "Y\r"
    
    expect "Remove test database and access to it? \[Y/n\]"
    send -- "Y\r"
    
    expect "Reload privilege tables now? \[Y/n\]"
    send -- "Y\r"
    
    expect eof
EOF

elif [ "$ubuntu_version" == "16.04" ]; then

lxc exec "$container_name" -- expect -f - <<-EOF
    log_user 0
    set timeout 10
    spawn mysql_secure_installation --user=root --password=$mysql_root_password
    
    # expect "Enter password for user root:"
    # send -- "$mysql_root_password\r"
    
    if { $validate_password_plugin == 0 } {
        # Would you like to setup VALIDATE PASSWORD plugin?
        expect "Press y|Y for Yes, any other key for No:"
        send -- "y\r"
        
        expect "Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:"
        send -- "2\r"
    }
    
    expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) :"
    send -- "\r"
    
    expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
    send -- "y\r"
    
    expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
    send -- "y\r"
    
    expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
    send -- "y\r"
    
    expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
    send -- "y\r"
    
    expect eof
EOF

fi

if [ $expect_already_installed -eq 0 ]; then
    # Remove the expect package and any other dependant packages which are no longer needed.
    # Also delete your local/config files for expect.
    lxc exec "$container_name" -- sh -c "$apt purge --auto-remove expect > /dev/null"
fi

#====================

mysql_version=$( lxc exec "$container_name" -- sh -c "mysql --version" | awk '{ print $5 }' | awk -F\, '{ print $1 }' )
echo "✓ MySQL Server $mysql_version installation is finished."
echo "🔑 Your MySQL Server's root password is: $mysql_root_password"

#---------------------------------------------------------------------------
