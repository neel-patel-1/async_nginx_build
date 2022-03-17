#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source $ROOT_DIR/build/qatengine_libsrcs.source
cd $ROOT_DIR/QAT_Engine
[ ! -d "${ROOT_DIR}/${QAT_BUILD}" ] && mkdir $QAT_BUILD


./autogen.sh
./configure \
--with-qat_hw_dir=$ICP_ROOT \
--enable-qat_gcm \
--with-openssl_install_dir=$ROOT_DIR/openssl \
--with-openssl_dir=$ROOT_DIR/openssl

PERL5LIB=$ROOT_DIR/openssl make -j35 -C .
sudo PERL5LIB=$ROOT_DIR/openssl make install -j

