#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source ../scripts/async_libsrcs.source
sudo rm -rf nginx_gzip_build
cd nginx-1.23.1
./configure --prefix=$(pwd)/../nginx_gzip_build  --add-module=$(pwd)/../nginx-nmp-overhead-module
make -j 30
make -j 30 install 
cd ../
cp ../SmartDIMM_gzip_nginx_conf/nginx_default.conf nginx_gzip_build/conf/nginx.conf
cp -r localhost.* nginx_gzip_build/conf/
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sudo ./nginx_gzip_build/sbin/nginx
cp UCFile_16K_1.txt nginx_gzip_build/html
