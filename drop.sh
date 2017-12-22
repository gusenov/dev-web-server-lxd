#!/bin/bash

# Usage:
#  $ "./drop.sh" --container="devel-web-server"
#  $ "./drop.sh" -c="devel-web-server"

source "./common/argument/container.sh"  # имя контейнера, который нужно удалить.

set -x # echo on

"./container/delete.sh" --container="$container"
