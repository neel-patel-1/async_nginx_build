#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ -z "$(cat /boot/config-$(uname -r) | grep -e 'CONFIG_TLS=m' -e 'CONFIG_TLS=y' )" ] && echo "TLS not enabled in kernel..." && exit
[ -z "$(lsmod | grep -e '\btls\b' )" ] && sudo modprobe tls

[ ! -d "${KTLS_DIR}" ] && mkdir -p ${KTLS_DIR}
cd ${KTLS_DIR}

#download openssl 3.0.0
[ ! -f "${KTLS_DIR}/openssl-3.0.0.tar.gz" ] && cd ${KTLS_DIR} && wget https://www.openssl.org/source/openssl-3.0.0.tar.gz
[ ! -d "${KTLS_DIR}/openssl-3.0.0" ] && cd ${KTLS_DIR} && tar xvf openssl-3.0.0.tar.gz

#install nginx with ktls
[ ! -f "${KTLS_DIR}/nginx-1.21.4.tar.gz" ] && wget https://nginx.org/download/nginx-1.21.4.tar.gz
[ ! -d "${KTLS_DIR}/nginx-1.21.4" ] && tar xzf nginx-1.21.4.tar.gz
if [ ! -f "${KTLS_DIR}/nginx_build/sbin/nginx" ]; then
	cd ${KTLS_DIR}/nginx-1.21.4
	[ ! -d "${KTLS_DIR}/nginx_build" ] && mkdir -p ${KTLS_DIR}/nginx_build
	[ ! -f "Makefile" ] && ./configure --prefix=${KTLS_DIR}/nginx_build \
	--with-ld-opt="-L ${KTLS_DIR}/openssl" \
	--with-http_ssl_module \
	--with-http_slice_module \
	--with-openssl=${KTLS_DIR}/openssl-3.0.0 \
	--with-openssl-opt=enable-ktls \
	--with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
	--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
	$* # additional args
	make -j $(( `nproc` / 2 ))
	sudo make install -j $(( `nproc` / 2 ))
fi
[ -z "$( ls ${KTLS_NGINX}/html/file_* )" ] && ${ROOT_DIR}/scripts/ktls/gen_http_files.sh
sudo cp -f ${ROOT_DIR}/ktls_nginx_conf/* ${KTLS_DIR}/nginx_build/conf	
