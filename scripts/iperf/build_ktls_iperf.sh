#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

cd $iperf_dir
[ ! -d "iperf_ssl" ] && git clone https://github.com/hselasky/iperf_ssl.git
[ ! -f "${KTLS_DIR}/openssl-3.0.0/libssl.so.3" ] && cd ${KTLS_DIR}/openssl-3.0.0 \
&& ./Configure enable-ktls \
&& make -j
if [ ! -f "iperf_ssl/bin/iperf" ]; then
	cd iperf_ssl
	env CFLAGS="-O2 -I${AXDIMM_OSSL_LIBS}/../include" LIBS="-l:libssl.so.1.1 -l:libcrypto.so.1.1" \
	LD_FLAGS="-L${AXDIMM_OSSL_LIBS}"\
	./configure --prefix=$(pwd)
	make -j 4
	make install -j 4
fi

