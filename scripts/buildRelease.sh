#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

#build driver
$ROOT_DIR/scripts/driver_build.sh
#establish groups for access if not done already
$ROOT_DIR/scripts/qat_groups.sh

#build QATZip 
#$ROOT_DIR/scripts/build_qatzip.sh

#build openssl
$ROOT_DIR/scripts/openssl_build.sh

#build QAT Engine
$ROOT_DIR/scripts/qatengine_build.sh
#copy qat benchmarking confs to etc
$ROOT_DIR/scripts/qatengine_confs.sh

#restart qat devices
sudo service qat_service restart
#test crypto operations
$ROOT_DIR/scripts/testcrypto.sh
