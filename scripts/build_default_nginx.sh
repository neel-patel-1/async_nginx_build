#!/bin/bash
echo "Building default nginx"

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source ${ROOT_DIR}/scripts/async_libsrcs.source
[ ! -d "${ROOT_DIR}/default_nginx" ] && mkdir $ROOT_DIR/default_nginx
cd $ROOT_DIR/default_nginx

wget http://nginx.org/download/nginx-1.20.1.tar.gz
tar -xvzf nginx-1.20.1.tar.gz

cd nginx-1.20.1
./configure --with-stream_ssl_module --with-ld-opt="-L $OPENSSL_LIB" --with-http_ssl_module --with-openssl=$OPENSSL_OFFLOAD/ --prefix=${ROOT_DIR}/default_nginx/nginx_build
make -j 35
sudo make install -j 35

#copy config file from root
sudo cp -r ${ROOT_DIR}/default_nginx_conf/* $DEFAULT_NGINX_BUILD/conf
sudo chmod o+r $DEFAULT_NGINX_BUILD/conf/localhost.key
sudo chmod o+w $DEFAULT_NGINX_BUILD/logs/error.log
