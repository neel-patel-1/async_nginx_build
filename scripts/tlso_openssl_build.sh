#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$DEFAULT_NGINX/openssl" ]; then
	cd $DEFAULT_NGINX
	git clone --depth 1 --branch OpenSSL_1_1_1e https://github.com/openssl/openssl.git
fi

cd $DEFAULT_NGINX/openssl
./Configure --prefix=${DEFAULT_NGINX}/openssl --openssldir=${DEFAULT_NGINX}/openssl/config_certs_keys linux-x86_64
make -j 35
sudo make install -j 35
