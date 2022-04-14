#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "$DEFAULT_DIR" ] && mkdir $DEFAULT_DIR
cd $DEFAULT_DIR

#openssl
cd ${DEFAULT_DIR}
if [ ! -d "${DEFAULT_OSSL}/lib" ]; then
	wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz
	tar xf openssl-1.1.1k.tar.gz
	cd openssl-1.1.1k
	./config --prefix=${DEFAULT_OSSL} --openssldir=${DEFAULT_OSSL}
	make -j
	sudo make install -j
	export PATH=${DEFAULT_OSSL}/bin:$PATH
	export LD_LIBRARY_PATH=${DEFAULT_OSSL}/lib
	cd ${DEFAULT_DIR}
	openssl version -v -e 
fi
if [ ! -d "$DEFAULT_NGINX_BIN" ]; then
	wget http://nginx.org/download/nginx-1.20.1.tar.gz
	tar -xvzf nginx-1.20.1.tar.gz
	cd nginx-1.20.1
	./configure --with-stream_ssl_module --with-ld-opt="-L ${DEFAULT_DIR}/openssl-1.1.1k" --with-http_ssl_module --with-openssl=${DEFAULT_DIR}/openssl-1.1.1k --prefix=${DEFAULT_DIR}/default_nginx
	make -j
	sudo make install -j 35
fi	
[ ! -f "${DEFAULT_NGINX}/conf/localhost.crt" ] && sudo cp -r ${ROOT_DIR}/default_nginx_conf/* ${DEFAULT_NGINX}/conf
[ ! -f "${DEFAULT_NGINX}/html/file_256K.txt" ] && ${DEFAULT_SCRIPTS}/gen_http_files.sh
[ ! -f "${DEFAULT_DIR}/default_nginx/sbin/nginx" ] && echo "NGINX BUILD FAILED" && exit
