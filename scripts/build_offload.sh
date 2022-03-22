#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source
${ROOT_DIR}/scripts/tlso_openssl_build.sh
${ROOT_DIR}/scripts/tlso_qatengine_build.sh
$ROOT_DIR/scripts/build_default_nginx.sh
