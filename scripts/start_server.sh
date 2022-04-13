#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

cd $NGINX_INSTALL_DIR/sbin
sudo ./nginx
netstat -tulpn | grep 443
