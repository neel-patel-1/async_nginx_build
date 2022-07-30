#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ -z "$(cat /boot/config-$(uname -r) | grep -e 'CONFIG_TLS=m' -e 'CONFIG_TLS=y' )" ] && echo "TLS not enabled in kernel..." && exit
[ -z "$(lsmod | grep -e '\btls\b' )" ] && sudo modprobe tls

#check for build
if [ ! -d "${KTLS_DIR}" ] || [ ! -f "${KTLS_DIR}/openssl-3.0.0.tar.gz" ] || [ ! -d "${KTLS_DIR}/openssl-3.0.0" ] || [ ! -f "${KTLS_DIR}/nginx-1.21.4.tar.gz" ] || [ ! -d "${KTLS_DIR}/nginx-1.21.4" ] || [ ! -f "${KTLS_DIR}/nginx_build/sbin/nginx" ]; then 
	echo "KTLS Directory not setup ..." 
	${ROOT_DIR}/scripts/ktls/ktls_build.sh >/dev/null
else
	sudo rm -rf ${KTLS_DIR}/nginx-1.21.4/Makefile ${KTLS_DIR}/nginx_build
	${ROOT_DIR}/scripts/ktls/ktls_build.sh $*
fi

