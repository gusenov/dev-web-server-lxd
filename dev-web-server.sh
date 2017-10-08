#!/bin/bash

# Usage:
#  $ "./dev-web-server.sh" -c="devel-web-server" -u="root" -p="Enter-Your-Password-Here"
#  $ "./dev-web-server.sh" --container="devel-web-server" --user="root" --password="Enter-Your-Password-Here"

source "./common/argument/container.sh"
source "./common/argument/user.sh"
source "./common/argument/password.sh"

set -x # echo on

################################################################################################################################

# Устанавливать лучше LTS-версии. Их можно посмотреть здесь: https://packages.ubuntu.com/
#  - trusty (14.04LTS)
#  - xenial (16.04LTS)

ubuntu_version="14.04"
#ubuntu_version="16.04"

################################################################################################################################

"./container/delete.sh" --container="$container"

"./container/create.sh" --container="$container" \
                        --version="$ubuntu_version"

"./common/output/colorful.sh" --colour="magenta" \
                              --format="b" \
                              --text="Information about your container:" 

"./container/info.sh"   --container="$container"

sleep 16

echo -n "Your server’s IP address: "
"./container/ip.sh"     --container="$container"

"./container/update.sh" --container="$container"

################################################################################################################################

"./common/output/colorful.sh" --colour="magenta" \
                              --format="b" \
                              --text="Installing Apache..." 

"./apache/install.sh" --container="$container"

################################################################################################################################

"./common/output/colorful.sh" --colour="magenta" \
                              --format="b" \
                              --text="Installing MySQL..." 

"./mysql/install.sh" --container="$container" \
                     --password="$password"

"./mysql/secure.sh" --container="$container" \
                    --user="$user" \
                    --password="$password"

################################################################################################################################

"./common/output/colorful.sh" --colour="magenta" \
                              --format="b" \
                              --text="Installing PHP..." 

case "$ubuntu_version" in
  "14.04") "./php/install.sh" --container="$container" \
                              --version="5" ;;

  "16.04") "./php/install.sh" --container="$container" \
                              --version="7.0" ;;
esac

################################################################################################################################

"./apache/restart.sh" --container="$container"
