#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

cd ${AXDIMM_DIR}/qat_cache_flush
LDFLAGS=\"-L$AXDIMM_DIR/intel-ipsec-mb/lib  \
-L$AXDIMM_DIR/lib\" \
CPPFLAGS=\"-I${AXDIMM_DIR}/intel-ipsec-mb/lib/include \
-I${AXDIMM_DIR}/include \
-I$AXDIMM_DIR/intel-ipsec-mb/lib \
-I$AXDIMM_DIR/crypto_mb/2020u3/include/crypto_mb \
-I$AXDIMM_DIR/crypto_mb/2020u3/include\" ./configure \
--enable-qat_sw \
--with-openssl_install_dir=${AXDIMM_DIR}/openssl \
--with-openssl_dir=${AXDIMM_DIR}/openssl \
--disable-qat_hw
PERL5LIB=$AXDIMM_DIR/openssl make -j $(( `nproc` / 2 ))
sudo PERL5LIB=$AXDIMM_DIR/openssl make install -j $(( `nproc` / 2 ))
