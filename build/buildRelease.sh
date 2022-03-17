#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

#build driver
$ROOT_DIR/build/driver_build.sh
#establish groups for access if not done already
$ROOT_DIR/build/qat_groups.sh

#build QATZip 
$ROOT_DIR/build/build_qatzip.sh

#build openssl
$ROOT_DIR/build/openssl_build.sh

#build QAT Engine
$ROOT_DIR/build/qatengine_build.sh
#copy qat engine confs to etc
$ROOT_DIR/build/qatengine_confs.sh

#restart qat devices
sudo service qat_service restart
#test crypto operations
$ROOT_DIR/build/testcrypto.sh
