#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

cd ${AXDIMM_TEST_DIR}/qat_tls_con_test
make clean -j 4
./autogen.sh
LDFLAGS="-L$AXDIMM_TEST_DIR/intel-ipsec-mb/lib  \
-L$AXDIMM_TEST_DIR/lib" \
CPPFLAGS="-I${AXDIMM_TEST_DIR}/intel-ipsec-mb/lib/include \
-I${AXDIMM_TEST_DIR}/include \
-I$AXDIMM_TEST_DIR/intel-ipsec-mb/lib \
-I$AXDIMM_TEST_DIR/crypto_mb/2020u3/include/crypto_mb \
-I$AXDIMM_TEST_DIR/crypto_mb/2020u3/include" ./configure \
--enable-qat_sw \
--disable-qat_hw \
--enable-qat_debug \
--with-qat_debug_file=${AXDIMM_TEST_DIR}/qat_debug_log \
--with-openssl_install_dir=${AXDIMM_TEST_DIR}/openssl \
--with-openssl_dir=${AXDIMM_TEST_DIR}/openssl
PERL5LIB=$AXDIMM_TEST_DIR/openssl make -j 4
sudo PERL5LIB=$AXDIMM_TEST_DIR/openssl make install -j 4
