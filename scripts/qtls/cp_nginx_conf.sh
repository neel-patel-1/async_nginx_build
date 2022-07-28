#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

sudo cp $ROOT_DIR/async_nginx_conf/nginx.conf_benchmark_all_ciphers_w_keepalive $QTLS_NGINX/conf/nginx.conf
