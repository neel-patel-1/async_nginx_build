#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "${QTLS_DIR}" ] && mkdir -p $QTLS_DIR
[ ! -d "${ROOT_DIR}/default_nginx" ] && mkdir $ROOT_DIR/default_nginx

[ ! -d "${IPSEC_INSTALL_LIB}" ] && ${ROOT_DIR}/scripts/build_ipsec.sh
[ ! -d "${CRYPTOMB_INSTALL_DIR}" ] && ${ROOT_DIR}/scripts/build_ipp_crypto.sh

[ ! -f "$OPENSSL_OFFLOAD/lib/libcrypto.so.1.1" ] && ${ROOT_DIR}/scripts/tlso_openssl_build.sh
[ ! -f "$OPENSSL_OFFLOAD_ENGINE/qatengine.so" ] && ${ROOT_DIR}/scripts/tlso_qatengine_build.sh


[ ! -f "$default_nginx_loc/nginx" ] && $ROOT_DIR/scripts/build_default_nginx.sh

#copy html files
${ROOT_DIR}/scripts/gen_http_files.sh
