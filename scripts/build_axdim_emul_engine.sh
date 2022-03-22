#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx


source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$BUILD_DIR/QAT_Engine" ]; then
	cd $BUILD_DIR
	git clone --depth 1 --branch v0.6.10 https://github.com/intel/QAT_Engine.git
fi
cd $BUILD_DIR/QAT_Engine


./autogen.sh
./configure \
--with-qat_hw_dir=$ICP_ROOT \
--with-openssl_install_dir=$BUILD_DIR/openssl \
--with-openssl_dir=$BUILD_DIR/openssl

PERL5LIB=$BUILD_DIR/openssl make -j35 -C .
sudo PERL5LIB=$BUILD_DIR/openssl make install -j


