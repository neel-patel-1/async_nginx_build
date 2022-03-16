#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source $ROOT_DIR/build/qtls_libs.src

[ ! -d "${ROOT_DIR}/testdir" ] && mkdir $ROOT_DIR/testdir

cd ${ROOT_DIR}/testdir
touch file.txt
cat /dev/zero | head -c 1G > file.txt

id -Gn

qzip -O 7z $ROOT_DIR/testdir -o $ROOT_DIR/testdirresult.7z

[ -d "${ROOT_DIR}/testdirresult.7z" ] && rm $ROOT_DIR/testdirresult.7z

#$ROOT_DIR/openssl/apps/openssl engine -t -c -v qatengine
#$ROOT_DIR/openssl/apps/openssl speed -engine qatengine rsa2048

