#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

cd $NGINX_INSTALL_DIR/sbin
sudo ./nginx
netstat -tulpn | grep 443
