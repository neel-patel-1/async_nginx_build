#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source $ROOT_DIR/build/qtls_libs.src

$ROOT_DIR/openssl/apps/openssl engine -t -c -v qatengine
