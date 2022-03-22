#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

cd $ROOT_DIR/qat_cache_flush

./autogen.sh
./configure \
--with-qat_hw_dir=$ICP_ROOT \
--with-openssl_install_dir=$DEFAULT_NGINX/openssl \
--with-openssl_dir=$DEFAULT_NGINX/openssl

PERL5LIB=$DEFAULT_NGINX/openssl make -j35 -C .
sudo PERL5LIB=$DEFAULT_NGINX/openssl make install -j
