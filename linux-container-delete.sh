#!/bin/bash 

#set -n  # Uncomment to check your syntax, without execution.
#set -x  # Uncomment to debug this shell script

container_name="devel-web-server"

lxc stop "$container_name"
echo "✓ Stopped container with name '$container_name'."

lxc delete "$container_name"
echo "✓ Removed container with name '$container_name'."
