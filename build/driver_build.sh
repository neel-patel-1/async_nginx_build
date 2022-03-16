#!/bin/bash

echo "Building QAT Driver"

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source ${ROOT_DIR}/build/async_libsrcs.source
[ ! -d "${ROOT_DIR}/QAT" ] && mkdir $ROOT_DIR/QAT
cd $ROOT_DIR/QAT
./configure
sudo make clean -j 35 
sudo make all -j 35 >& make.txt
sudo make install -j 35 >& makeinstall.txt
