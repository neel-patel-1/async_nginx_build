#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

cd ${AXDIMM_TEST_DIR}/qat_tls_con_test
LDFLAGS=\"-L$AXDIMM_TEST_DIR/intel-ipsec-mb/lib  \
-L$AXDIMM_TEST_DIR/lib\" \
CPPFLAGS=\"-I${AXDIMM_TEST_DIR}/intel-ipsec-mb/lib/include \
-I${AXDIMM_TEST_DIR}/include \
-I$AXDIMM_TEST_DIR/intel-ipsec-mb/lib \
-I$AXDIMM_TEST_DIR/crypto_mb/2020u3/include/crypto_mb \
-I$AXDIMM_TEST_DIR/crypto_mb/2020u3/include\" ./configure \
--enable-qat_sw \
--with-openssl_install_dir=${AXDIMM_TEST_DIR}/openssl \
--with-openssl_dir=${AXDIMM_TEST_DIR}/openssl \
--disable-qat_hw \
--enable-qat_debug \
--with-qat_debug_file=${AXDIMM_TEST_DIR}/axdimm_debug.txt
PERL5LIB=$AXDIMM_TEST_DIR/openssl make -j $(( `nproc` / 2 ))
sudo PERL5LIB=$AXDIMM_TEST_DIR/openssl make install -j $(( `nproc` / 2 ))
