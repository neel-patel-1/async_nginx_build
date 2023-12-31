#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
#source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "$ROOT_DIR/kvs" ] && mkdir $ROOT_DIR/kvs
cd $ROOT_DIR/kvs
[ ! -f "libevent-2.1.12-stable.tar.gz" ] && wget --no-check-certificate https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
[ ! -d "libevent-2.1.12-stable" ]  && tar -xzf libevent-2.1.12-stable.tar.gz
if [ ! -d "$(pwd)/libevent_build" ]; then
	cd libevent-2.1.12-stable
	./configure --prefix=$(pwd)/../libevent_build
	make -j 4
	make install -j 4
fi

cd $ROOT_DIR/kvs
#[ ! -d "memcached" ] && git clone --depth 1 --branch 1.6.17 https://github.com/memcached/memcached
[ ! -d "memcached_ctx_ktls" ]  && git clone git@github.com:neelpatelbiz/memcached_ctx_ktls.git
cd memcached_ctx_ktls
#if [ ! -f "$(pwd)/../ktls_mem_build/bin/memcached" ]; then
	# -Werror flag in makefile is preventing engine build due to warnings as errors , do we need to sed it out?
env \
LDFLAGS="-L/home/n869p538/wrk_offloadenginesupport/async_nginx_build/ktls/openssl-3.0.0" \
CFLAGS="-g -O2 -pthread -pthread -Wall -pedantic -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls" \
./configure --prefix=$(pwd)/../ktls_mem_build \
--with-libssl=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/ktls/openssl-3.0.0 \
--enable-tls \
--with-libevent=$(pwd)/../libevent_build
sed -i -E 's/CFLAGS = (.*)-Werror(.*)/CFLAGS = \1\2/g' Makefile
make -j 4
make install -j 4
#fi
cd ../
[ ! -f "openssl.cnf" ] && cp -r /etc/ssl/openssl.cnf .
export OPENSSL_CONF=$(pwd)/openssl.cnf
[ ! -f "cert.pem" ] || [ ! -f "key.pem" ] && openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes
