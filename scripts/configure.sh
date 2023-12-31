#!/bin/bash
newroot=$(echo "$(pwd)" | sed 's/\//\\\//g')
sudo grep -rn "^export ROOT_DIR" * | awk -F':' '{print $1}' | grep -E -e 'nginx.sh' -e 'nginxs/*' -e 'scripts.*\.(sh|src|source)$' | xargs sudo sed -i "s/export ROOT_DIR=.*/export ROOT_DIR=${newroot}/"
sudo apt-get install build-essential autoconf automake libpcre3-dev libevent-dev pkg-config zlib1g-dev libssl-dev
