#!/bin/bash
#nginx server
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "$AXDIMM_DIR" ] && mkdir -p $AXDIMM_DIR
wget http://nginx.org/download/nginx-1.20.1.tar.gz
tar -xvzf nginx-1.20.1.tar.gz
cd nginx-1.20.1
./configure --with-stream_ssl_module --with-ld-opt="-L ${AXDIMM_DIR}/openssl-1.1.1k" --with-http_ssl_module --with-openssl=${AXDIMM_DIR}/openssl-1.1.1k --prefix=${AXDIMM_DIR}/offload_nginx
make -j
sudo make install -j 35
cp -r ${ROOT_DIR}/default_nginx_conf/* ${AXDIMM_DIR}/offload_nginx/conf
[ ! -f "${AXDIMM_NGINX}/sbin/nginx" ] && echo "NGINX BUILD FAILED" && exit
exit
