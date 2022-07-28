#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "$DEFAULT_DIR" ] && mkdir $DEFAULT_DIR
cd $DEFAULT_DIR

#openssl
cd ${DEFAULT_DIR}

[ ! -f "${DEFAULT_DIR}/openssl-3.0.0.tar.gz" ] && cd ${DEFAULT_DIR} && wget https://www.openssl.org/source/openssl-3.0.0.tar.gz
[ ! -d "${DEFAULT_DIR}/openssl-3.0.0" ] && cd ${DEFAULT_DIR} && tar xvf openssl-3.0.0.tar.gz

[ ! -f "${DEFAULT_DIR}/nginx-1.21.4.tar.gz" ] && wget https://nginx.org/download/nginx-1.21.4.tar.gz
[ ! -d "${DEFAULT_DIR}/nginx-1.21.4" ] && tar xzf nginx-1.21.4.tar.gz
if [ ! -f "${DEFAULT_DIR}/nginx_build/sbin/nginx" ]; then
	cd ${DEFAULT_DIR}/nginx-1.21.4
	[ ! -d "${DEFAULT_DIR}/nginx_build" ] && mkdir -p ${DEFAULT_DIR}/nginx_build
	[ ! -f "Makefile" ] && ./configure --prefix=${DEFAULT_DIR}/nginx_build \
	--with-ld-opt="-L ${DEFAULT_DIR}/openssl" \
	--with-http_ssl_module \
	--with-http_slice_module \
	--with-openssl=${DEFAULT_DIR}/openssl-3.0.0 \
	--with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
	--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
	$* # additional args
	make -j $(( `nproc` / 2 ))
	sudo make install -j $(( `nproc` / 2 ))
fi
[ -z "$( ls ${DEFAULT_NGINX}/html/file_* )" ] && ${ROOT_DIR}/scripts/default/gen_http_files.sh
[ ! -f "${DEFAULT_NGINX}/conf/localhost.crt" ] && sudo cp -r ${ROOT_DIR}/default_nginx_conf/* ${DEFAULT_NGINX}/conf
[ ! -f "${DEFAULT_DIR}/default_nginx/sbin/nginx" ] && echo "DEFAULT NGINX BUILD FAILED" && exit
