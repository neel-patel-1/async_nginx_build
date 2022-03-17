#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$BUILD_DIR/openssl" ]; then
	cd $BUILD_DIR
	git clone --depth 1 --branch OpenSSL_1_1_1j https://github.com/openssl/openssl.git
fi

cd $BUILD_DIR/openssl
./Configure --prefix=${BUILD_DIR}/openssl --openssldir=${BUILD_DIR}/openssl/config_certs_keys linux-x86_64
make -j 35
sudo make install -j 35
