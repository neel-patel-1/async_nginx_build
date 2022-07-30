#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d $ROOT_DIR/kvs ] && mkdir $ROOT_DIR/kvs
cd $ROOT_DIR/kvs
[ ! -f "libevent-2.1.12-stable.tar.gz" ] && wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
[ ! -d "libevent-2.1.12-stable" ]  && tar -xzf libevent-2.1.12-stable.tar.gz
if [ ! -d "$(pwd)/libevent_build" ]; then
	cd libevent-2.1.12-stable
	./configure --prefix=$(pwd)/../libevent_build
	make -j 4
	make install -j 4
fi

cd $ROOT_DIR/kvs
[ ! -f "memcached-1.6.15.tar.gz" ] &&  wget http://www.memcached.org/files/memcached-1.6.15.tar.gz
[ ! -d "memcached-1.6.15" ] && tar -xzf memcached-1.6.15.tar.gz
[ ! -d "memcached-1.6.15_patched" ] && patch -s -p0 < offload.patch && mv memcached-1.6.15 memcached-1.6.15_patched
cd memcached-1.6.15_patched
if [ ! -f "$(pwd)/../memcached_build/bin/memcached" ]; then
	# -Werror flag in makefile is preventing engine build due to warnings as errors , do we need to sed it out?
	./configure --prefix=$(pwd)/../memcached_build \
	--enable-tls \
	--with-libevent=$(pwd)/../libevent_build \
	--with-libssl=$AXDIMM_OSSL_LIBS/..
	sed -i -E 's/CFLAGS = (.*)-Werror(.*)/CFLAGS = \1\2/g' Makefile

	make -j 4
	make install -j 4
fi
cd ../
[ ! -f "openssl.cnf" ] && cp -r /etc/ssl/openssl.cnf .
export OPENSSL_CONF=$(pwd)/openssl.cnf
[ ! -f "cert.pem" ] || [ ! -f "key.pem" ] && openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes
