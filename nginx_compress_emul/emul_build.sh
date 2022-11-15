#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source ../scripts/async_libsrcs.source
../scripts/L5P_DRAM_Experiments/setup_server.sh
sudo rm -rf nginx_gzip_build
cd nginx-1.23.1
./configure --prefix=$(pwd)/../nginx_gzip_build  --with-debug --add-module=$(pwd)/../nginx-nmp-overhead-module
make -j 30
make -j 30 install 
cd ../
cp nginx_default.conf nginx_gzip_build/conf/nginx.conf
cp -r localhost.* nginx_gzip_build/conf/
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sudo ./nginx_gzip_build/sbin/nginx
../scripts/L5P_DRAM_Experiments/setup_compression_corpus.sh 16K
