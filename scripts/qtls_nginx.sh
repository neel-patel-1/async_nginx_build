#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/qtls_libs.src

sudo $NGINX_INSTALL_DIR/sbin/nginx -t
sudo $NGINX_INSTALL_DIR/sbin/nginx
