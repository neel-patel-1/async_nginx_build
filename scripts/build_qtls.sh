#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

#build driver
[ ! -f "${BUILD_DIR}/QAT/quickassist/qat/drivers/crypto/qat/qat_c62x/qat_c62x.ko" ] && $ROOT_DIR/scripts/driver_build.sh
#establish groups for access if not done already
$ROOT_DIR/scripts/qat_groups.sh

#build QATZip 
#$ROOT_DIR/scripts/build_qatzip.sh

#build openssl
[ ! -f "$OPENSSL_LIBS/libcrypto.so.1.1" ] && $ROOT_DIR/scripts/openssl_build.sh

#build QAT Engine
[ ! -f "$OPENSSL_LIBS/engines-1.1/qatengine.so" ] && $ROOT_DIR/scripts/qatengine_build.sh

#build aync mode nginx
[ ! -f "$BUILD_DIR/async_mode_nginx_build/sbin/nginx" ] && $ROOT_DIR/scripts/async_nginx_build.sh
Builds/async_mode_nginx_build/sbin/nginx

#use benchmarking qat device confs
$ROOT_DIR/scripts/benchmark_qat_conf.sh
#use benchmarking nginx conf
$ROOT_DIR/scripts/cp_nginx_conf.sh
#copy html files
${ROOT_DIR}/gen_http_files.sh

#restart qat devices
sudo service qat_service restart