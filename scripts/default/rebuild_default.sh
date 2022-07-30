#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "${DEFAULT_DIR}" ] || [ ! -f "${DEFAULT_DIR}/openssl-3.0.0.tar.gz" ] || [ ! -d "${DEFAULT_DIR}/openssl-3.0.0" ] || [ ! -f "${DEFAULT_DIR}/nginx-1.21.4.tar.gz" ] || [ ! -d "${DEFAULT_DIR}/nginx-1.21.4" ] || [ ! -f "${DEFAULT_DIR}/nginx_build/sbin/nginx" ]; then 
	echo "DEFAULT Directory not setup ..." 
	${ROOT_DIR}/scripts/default/build_default.sh >/dev/null
else
	sudo rm -rf ${DEFAULT_DIR}/nginx-1.21.4/Makefile ${DEFAULT_DIR}/nginx_build
	${ROOT_DIR}/scripts/default/build_default.sh $*
fi

