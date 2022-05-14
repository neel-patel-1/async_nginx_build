#!/bin/bash
newroot=$(echo "$(pwd)" | sed 's/\//\\\//g')
grep -rn "^export ROOT_DIR" * | awk -F':' '{print $1}' | grep -E 'scripts.*\.(sh|src|source)$' | xargs sed -i "s/export ROOT_DIR=.*/export ROOT_DIR=${newroot}/"
sudo apt install libpcre3-dev

exit

# what does below replace?
newopenssl=${newroot}\\/builds\\/openssl
newopenssllib=$newopenssl\\/lib
newopensslengines=$newopenssllib\\/engines-1.1
sed -i -e "s/export OPENSSL_ENGINES=.*/export OPENSSL_ENGINES=${newopensslengines}/" -e "s/export LD_FLAGS=.*/export LD_FLAGS=${newopenssl}/" $(pwd)/scripts/qtls_libs.src


sed -i -e "s/export LD_LIBRARY_PATH=.*(:.*:.*_)/export LD_LIBRARY_PATH=${newopensslengines}:/" -e "s/export LD_FLAGS=.*/export LD_FLAGS=${newopenssl}/" $(pwd)/scripts/qtls_libs.src


[ ! -d "$(pwd)/Builds" ] && mkdir $(pwd)/Builds

newroot=$(echo "$(pwd)" | sed 's/\//\\\//g')
grep -rn "^export ROOT_DIR" * | awk -F':' '{print $1}' | grep -E 'scripts.*\.(sh|src|source)$' | xargs sed -i "s/export ROOT_DIR=.*/export ROOT_DIR=${newroot}/"
