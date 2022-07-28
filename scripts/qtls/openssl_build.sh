#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$QTLS_DIR/openssl" ]; then
	cd $QTLS_DIR
	git clone --depth 1 --branch OpenSSL_1_1_1j https://github.com/openssl/openssl.git
fi

cd $QTLS_DIR/openssl
./Configure --prefix=${QTLS_DIR}/openssl --openssldir=${QTLS_DIR}/openssl/config_certs_keys linux-x86_64
make -j 35
sudo make install -j 35
