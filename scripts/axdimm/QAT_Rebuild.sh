#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

if [ -d "${AXDIMM_DIR}/QAT_Engine" ]; then
	cd ${AXDIMM_DIR}
	cd QAT_Engine
	./autogen.sh
	#only link against Multi-Buffer
	LDFLAGS="-L/opt/intel-ipsec-mb/lib " \
	CPPFLAGS="-I/opt/intel-ipsec-mb/lib/include \
	-I$AXDIMM_DIR/crypto_mb/2020u3/include/crypto_mb \
	-I$AXDIMM_DIR/crypto_mb/2020u3/include" ./configure \
	--enable-qat_sw \
	--with-openssl_install_dir=${AXDIMM_DIR}/openssl \
	--with-openssl_dir=${AXDIMM_DIR}/openssl \
	--disable-qat_hw \
	--enable-qat_debug #keep debug for now to verify our sw changes
	cp -f ${ROOT_DIR}/axdimm_aes_gcm/qat_sw_gcm.c .
	PERL5LIB=$AXDIMM_DIR/openssl make -j
	sudo PERL5LIB=$AXDIMM_DIR/openssl make install

fi
