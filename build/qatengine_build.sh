#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

cd $ROOT_DIR/QAT_Engine
source qatengine_libsrcs.source
[ ! -d "$QAT_BUILD" ] && mkdir $QAT_BUILD

./autogen.sh
./configure --enable-qat_sw \
--enable-qat_hw \
--with-openssl_install_dir=$ROOT_DIR/openssl \
--with-openssl_dir=$ROOT_DIR/openssl \
--prefix=$QAT_BUILD \
--exec-prefix=$QAT_BUILD

PERL5LIB=$ROOT_DIR/openssl make -j35 -C .
sudo PERL5LIB=$ROOT_DIR/openssl make install -j
