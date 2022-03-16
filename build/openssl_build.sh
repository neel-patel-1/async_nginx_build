#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
cd $ROOT_DIR/openssl
./Configure --prefix=${ROOT_DIR}/openssl --openssldir=${ROOT_DIR}/openssl/config_certs_keys linux-x86_64
make -j 35
sudo make install -j 35
