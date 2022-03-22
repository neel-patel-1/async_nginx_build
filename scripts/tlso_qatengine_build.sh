#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$DEFAULT_NGINX/qat_cache_flush" ]; then
	cd $DEFAULT_NGINX
	git clone git@gitlab.ittc.ku.edu:n869p538/qat_cache_flush.git
fi

cd $DEFAULT_NGINX/qat_cache_flush

./autogen.sh
./configure \
--enable-qat_sw \
--with-openssl_install_dir=$OPENSSL_OFFLOAD \
--with-openssl_dir=$OPENSSL_OFFLOAD \
--disable-qat_hw

PERL5LIB=$DEFAULT_NGINX/openssl make -j35 -C .
sudo PERL5LIB=$DEFAULT_NGINX/openssl make install -j
