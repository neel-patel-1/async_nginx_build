#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

#build driver
$ROOT_DIR/scripts/driver_build.sh
#establish groups for access if not done already
$ROOT_DIR/scripts/qat_groups.sh

#build openssl
$ROOT_DIR/scripts/openssl_build.sh

#build QAT Engine
$ROOT_DIR/scripts/qatengine_build.sh

#use benchmarking qat device confs
$ROOT_DIR/scripts/benchmark_qat_conf.sh
#use benchmarking nginx conf
$ROOT_DIR/scripts/cp_nginx_conf.sh

#build offload nginx ++ openssl ++ qatengine
$ROOT_DIR/scripts/build_offload.sh

#restart qat devices
sudo service qat_service restart
