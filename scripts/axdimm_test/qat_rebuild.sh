#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

cd ${AXDIMM_TEST_DIR}
cd openssl
sudo make clean -j 4
./Configure --prefix=$AXDIMM_DIR/openssl --openssldir=$AXDIMM_DIR/openssl/config_certs_keys linux-x86_64 
echo "compiling openssl ..."
2>1 >/dev/null make -j 4
echo "installing openssl ..."
2>1 >/dev/null sudo make install -j 4

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
--with-openssl_install_dir=${AXDIMM_TEST_DIR}/openssl \
--with-openssl_dir=${AXDIMM_TEST_DIR}/openssl
PERL5LIB=$AXDIMM_TEST_DIR/openssl make -j 4
sudo PERL5LIB=$AXDIMM_TEST_DIR/openssl make install -j 4
