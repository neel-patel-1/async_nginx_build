#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/qtls_libs.src

sudo $NGINX_INSTALL_DIR/sbin/nginx -t
sudo $NGINX_INSTALL_DIR/sbin/nginx
