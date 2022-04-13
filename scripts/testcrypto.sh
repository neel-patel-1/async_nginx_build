#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build

source $ROOT_DIR/scripts/qtls_libs.src

$ROOT_DIR/openssl/apps/openssl engine -t -c -v qatengine

echo "rsa blocks w engine"
$ROOT_DIR/openssl/apps/openssl speed -engine qatengine rsa2048 | grep '^rsa'
echo "rsa blocks w/o engine" | grep '^rsa'
$ROOT_DIR/openssl/apps/openssl speed rsa2048


echo "aes256 blocks w engine"
$ROOT_DIR/openssl/apps/openssl speed -engine qatengine -evp AES256 |& grep '^aes'
echo "aes256 blocks w/o engine"
$ROOT_DIR/openssl/apps/openssl speed -evp AES256 |& grep '^aes'
