#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "${AXDIMM_DIR}" ] && mkdir -p ${AXDIMM_DIR}


export AXDIMM_DEPS="cmake nasm zlib1g-dev autoconf libtool-bin"
for i in $AXDIMM_DEPS; do
	[ -z "$( dpkg -l | grep $i )" ] \
	&& echo "missing package $i ... installing" \
	&& 2>&1 1>/dev/null sudo apt install $i
done

if [ ! -f "${AXDIMM_DIR}/openssl/lib/libcrypto.so.1.1" ]; then
	cd ${AXDIMM_DIR}
	git clone --depth 1 --branch OpenSSL_1_1_1d https://github.com/openssl/openssl.git
	cd openssl
	./Configure --prefix=$AXDIMM_DIR/openssl --openssldir=$AXDIMM_DIR/openssl/config_certs_keys linux-x86_64 
	make -j $(( `nproc` / 2 ))
	sudo make install -j $(( `nproc` / 2 ))
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
	cmake . -Bbuild -DCMAKE_INSTALL_PREFIX=$AXDIMM_DIR/crypto_mb/2020u3 -DARCH=intel64 -DOPENSSL_ROOT_DIR=${AXDIMM_DIR}/openssl
	cd build
	make -j $(( `nproc` / 2 ))
	sudo make install -j $(( `nproc` / 2 ))
fi

cd ${AXDIMM_DIR}
[ ! -d "intel-ipsec-mb" ] && git clone https://github.com/intel/intel-ipsec-mb.git
if [ ! -f "${AXDIMM_DIR}/lib/libIPSec_MB.so" ]; then
	cd intel-ipsec-mb
	git checkout v0.55
	make -j $(( `nproc` / 2 )) SAFE_DATA=y SAFE_PARAM=y SAFE_LOOKUP=y # unknown types
	sudo make install NOLDCONFIG=y PREFIX=$AXDIMM_DIR
fi

#build qatengine regardless
cd ${AXDIMM_DIR}
if [ ! -d "qat_cache_flush" ];  then
	git clone git@gitlab.ittc.ku.edu:n869p538/qat_cache_flush.git
fi
cd qat_cache_flush
git reset --hard ac534533ff661ddde9e766c07d2b67468409ac13
if [ ! -f "$AXDIMM_ENGINES/qatengine.so" ] || [ "$qat_mod" = "y" ]; then
	sudo make clean -j $(( `nproc` / 2 ))
	./autogen.sh
	#only link against Multi-Buffer
	LDFLAGS="-L$AXDIMM_DIR/intel-ipsec-mb/lib  \
	-L$AXDIMM_DIR/lib"\
	CPPFLAGS="-I$AXDIMM_DIR/intel-ipsec-mb/lib/include \
	-I$AXDIMM_DIR/intel-ipsec-mb/lib \
	-I$AXDIMM_DIR/crypto_mb/2020u3/include/crypto_mb \
	-I$AXDIMM_DIR/crypto_mb/2020u3/include" ./configure \
	--enable-qat_sw \
	--with-openssl_install_dir=${AXDIMM_DIR}/openssl \
	--with-openssl_dir=${AXDIMM_DIR}/openssl \
	--disable-qat_hw
	PERL5LIB=$AXDIMM_DIR/openssl make -j $(( `nproc` / 2 ))
	sudo PERL5LIB=$AXDIMM_DIR/openssl make install -j $(( `nproc` / 2 ))
fi

if [ ! -d "${AXDIMM_DIR}/nginx_build" ]; then
	cd ${AXDIMM_DIR}
	[ ! -f "nginx-1.20.1.tar.gz" ] && wget http://nginx.org/download/nginx-1.20.1.tar.gz
	[ ! -d "nginx-1.20.1" ] && tar -xvzf nginx-1.20.1.tar.gz
	cd nginx-1.20.1/
	sudo ./configure --with-ld-opt="-L ${AXDIMM_DIR}/openssl" --with-http_ssl_module --with-http_random_index_module --with-openssl=${AXDIMM_DIR}/openssl --prefix=${AXDIMM_DIR}/nginx_build
	make -j $(( `nproc` / 2 ))
	sudo make install -j $(( `nproc` / 2 ))
fi


#load mmappable scull char dev for offload emulation
make -C ${CHAR_DIR}
if [ -z "$(lsmod | grep scullc)" ]; then
	cd ${CHAR_DIR}
	sudo ${CHAR_DIR}/scullc_load
fi

sudo cp -r ${ROOT_DIR}/axdimm_nginx_confs/* ${AXDIMM_DIR}/nginx_build/conf
${AXDIMM_SCRIPTS}/gen_http_files.sh
