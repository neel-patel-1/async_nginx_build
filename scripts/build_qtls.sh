#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

#build driver
[ ! -f "${QTLS_DIR}/QAT/quickassist/qat/drivers/crypto/qat/qat_c62x/qat_c62x.ko" ] && ${QTLS_SCRIPTS}/driver_build.sh
#establish groups for access if not done already
${QTLS_SCRIPTS}/qat_groups.sh

#build openssl
[ ! -f "$OPENSSL_LIBS/libcrypto.so.1.1" ] && ${QTLS_SCRIPTS}/openssl_build.sh

#build QAT Engine
[ ! -f "$OPENSSL_LIBS/engines-1.1/qatengine.so" ] && ${QTLS_SCRIPTS}/qatengine_build.sh

#build aync mode nginx
[ ! -f "$QTLS_DIR/async_mode_nginx_build/sbin/nginx" ] && ${QTLS_SCRIPTS}/async_nginx_build.sh

#use benchmarking qat device confs
${QTLS_SCRIPTS}/benchmark_qat_conf.sh
#use benchmarking nginx conf
${QTLS_SCRIPTS}/cp_nginx_conf.sh
#copy html files
${QTLS_SCRIPTS}/gen_http_files.sh

#restart qat devices
sudo service qat_service restart
