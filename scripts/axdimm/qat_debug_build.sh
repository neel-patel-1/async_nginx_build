#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "${AXDIMM_DIR}" ] && mkdir -p ${AXDIMM_DIR}

if [ ! -f "${AXDIMM_DIR}/openssl/lib/libcrypto.so.1.1" ]; then
	cd ${AXDIMM_DIR}
	git clone --depth 1 --branch OpenSSL_1_1_1d https://github.com/openssl/openssl.git
	cd openssl
	./Configure --prefix=$AXDIMM_DIR/openssl --openssldir=$AXDIMM_DIR/openssl/config_certs_keys linux-x86_64 
	echo "compiling openssl ..."
	2>1 >/dev/null make -s -j 4
	echo "installing openssl ..."
	sudo make --silent install -j 35
else
	cd ${AXDIMM_DIR}
	cd openssl
	#sudo make -s clean -j 4
	#./Configure --prefix=$AXDIMM_DIR/openssl --openssldir=$AXDIMM_DIR/openssl/config_certs_keys linux-x86_64 
	echo "compiling openssl ..."
	#make --silent -j 4
	echo "installing openssl ..."
	#sudo make -s install -j 4
fi

cd ${AXDIMM_DIR}/qat_cache_flush
make clean -j 4
./autogen.sh
LDFLAGS="-L$AXDIMM_DIR/intel-ipsec-mb/lib  \
-L$AXDIMM_DIR/lib" \
CPPFLAGS="-I${AXDIMM_DIR}/intel-ipsec-mb/lib/include \
-I${AXDIMM_DIR}/include \
-I$AXDIMM_DIR/intel-ipsec-mb/lib \
-I$AXDIMM_DIR/crypto_mb/2020u3/include/crypto_mb \
-I$AXDIMM_DIR/crypto_mb/2020u3/include" ./configure \
--enable-qat_sw \
--disable-qat_hw \
--enable-qat_debug \
--with-qat_debug_file=${AXDIMM_DIR}/qat_debug_log \
--with-openssl_install_dir=${AXDIMM_DIR}/openssl \
--with-openssl_dir=${AXDIMM_DIR}/openssl
PERL5LIB=$AXDIMM_DIR/openssl make -j 4
sudo PERL5LIB=$AXDIMM_DIR/openssl make install -j 4
