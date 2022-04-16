#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "${AXDIMM_DIR}" ] && mkdir -p ${AXDIMM_DIR}

if [ ! -f "${AXDIMM_DIR}/openssl/lib/libcrypto.so.1.1" ]; then
	cd ${AXDIMM_DIR}
	git clone --depth 1 --branch OpenSSL_1_1_1d https://github.com/openssl/openssl.git
	cd openssl
	./Configure --prefix=$AXDIMM_DIR/openssl --openssldir=$AXDIMM_DIR/openssl/config_certs_keys linux-x86_64 
	make -j 40
	sudo make install -j40
else
	cd ${AXDIMM_DIR}/openssl
	sudo make clean -j
	./Configure --prefix=$AXDIMM_DIR/openssl --openssldir=$AXDIMM_DIR/openssl/config_certs_keys linux-x86_64 
	make -j 40
	sudo make install -j40
	
fi

if [ ! -f "${AXDIMM_DIR}/crypto_mb/2020u3/lib/intel64/libcrypto_mb.so" ]; then
	cd ${AXDIMM_DIR}
	git clone https://github.com/intel/ipp-crypto.git
	cd ipp-crypto
	git checkout ipp-crypto_2021_5
	cmake . -Bbuild -DCMAKE_INSTALL_PREFIX=$AXDIMM_DIR/crypto_mb/2020u3 -DARCH=intel64
	cd build
	make -j
	sudo make install -j
fi

cd ${AXDIMM_DIR}
if [ ! -f "${AXDIMM_DIR}/lib/libIPSec_MB.so" ]; then
	git clone https://github.com/intel/intel-ipsec-mb.git
	cd intel-ipsec-mb
	git checkout v0.55
	make -j SAFE_DATA=y SAFE_PARAM=y SAFE_LOOKUP=y # unknown types
	sudo make install NOLDCONFIG=y PREFIX=$AXDIMM_DIR
fi

#build qatengine regardless
cd ${AXDIMM_DIR}
[ ! -d "qat_cache_flush" ] && git clone git@gitlab.ittc.ku.edu:n869p538/qat_cache_flush.git
cd qat_cache_flush
make clean -j
./autogen.sh
#only link against Multi-Buffer
LDFLAGS="-L$AXDIMM_DIR/intel-ipsec-mb/lib " \
CPPFLAGS="-I$AXDIMM_DIR/intel-ipsec-mb/lib/include \
-I$AXDIMM_DIR/crypto_mb/2020u3/include/crypto_mb \
-I$AXDIMM_DIR/crypto_mb/2020u3/include" ./configure \
--enable-qat_sw \
--with-openssl_install_dir=${AXDIMM_DIR}/openssl \
--with-openssl_dir=${AXDIMM_DIR}/openssl \
--disable-qat_hw
PERL5LIB=$AXDIMM_DIR/openssl make -j
sudo PERL5LIB=$AXDIMM_DIR/openssl make install

if [ ! -d "${AXDIMM_DIR}/nginx_build" ]; then
	cd ${AXDIMM_DIR}
	[ ! -f "nginx-1.20.1.tar.gz" ] && wget http://nginx.org/download/nginx-1.20.1.tar.gz
	[ ! -d "nginx-1.20.1" ] && tar -xvzf nginx-1.20.1.tar.gz
	cd nginx-1.20.1/
	./configure --with-ld-opt="-L ${AXDIMM_DIR}/openssl" --with-http_ssl_module --with-openssl=${AXDIMM_DIR}/openssl --prefix=${AXDIMM_DIR}/nginx_build
	make -j 
	sudo make install -j
fi

sudo cp -r ${ROOT_DIR}/axdimm_nginx_confs/* ${AXDIMM_DIR}/nginx_build/conf
${AXDIMM_SCRIPTS}/gen_http_files.sh
