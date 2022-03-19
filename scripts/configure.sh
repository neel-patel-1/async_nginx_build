#!/bin/bash
newroot=$(echo "$(pwd)" | sed 's/\//\\\//g')
grep -rn "^export ROOT_DIR" * | awk -F':' '{print $1}' | grep -E 'scripts.*\.(sh|src|source)$' | xargs sed -i "s/export ROOT_DIR=.*/export ROOT_DIR=${newroot}/"
