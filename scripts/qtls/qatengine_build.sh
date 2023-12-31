#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build


source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$QTLS_DIR/QAT_Engine" ]; then
	cd $QTLS_DIR
	git clone --depth 1 --branch v0.6.10 https://github.com/intel/QAT_Engine.git
fi
cd $QTLS_DIR/QAT_Engine


./autogen.sh
./configure \
--with-qat_hw_dir=$ICP_ROOT \
--with-openssl_install_dir=$QTLS_DIR/openssl \
--with-openssl_dir=$QTLS_DIR/openssl

PERL5LIB=$QTLS_DIR/openssl make -j35 -C .
sudo PERL5LIB=$QTLS_DIR/openssl make install -j
