#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

cd $iperf_dir
[ ! -d "iperf_ssl" ] && git clone https://github.com/Mellanox/iperf_ssl.git
[ ! -f "${KTLS_DIR}/openssl-3.0.0/libssl.so.3" ] && cd ${KTLS_DIR}/openssl-3.0.0 \
&& ./Configure enable-ktls \
&& make -j
if [ ! -f "iperf_ssl/bin/iperf" ]; then
	cd iperf_ssl
	env \
	LIBS="-lrt -lssl -lcrypto"
	LDFLAGS="-L/usr/local/lib -lcrypto -lssl" \
	CFLAGS="-I/usr/local/include" \
	./configure --prefix=$(pwd)/../ktls_iperf_build
	#--enable-tls \
	#--with-libssl=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/ktls/openssl-3.0.0 \
	#--with-libevent=$(pwd)/../libevent_build
	exit
	make -j 4
	make install -j 4
fi

