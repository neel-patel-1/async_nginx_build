#!/bin/bash

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

sudo cp $ROOT_DIR/async_nginx_conf/nginx.conf_benchmark_all_ciphers_w_keepalive $NGINX_INSTALL_DIR/conf/nginx.conf