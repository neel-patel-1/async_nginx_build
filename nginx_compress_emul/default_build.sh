#!/bin/bash
sudo rm -rf nginx_default_build
mkdir -p nginx_default_src && tar -xf nginx-1.23.1.tar.gz -C nginx_default_src --strip-components 1
cd nginx_default_src
./configure --add-module=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/nginx_compress_emul/dummy-filter-module --prefix=$(pwd)/../nginx_default_build
make -j 30
make -j 30 install 
cd ../
sudo cp nginx_dummy.conf nginx_default_build/conf/nginx.conf
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sudo ./nginx_default_build/sbin/nginx
head -c 256K < /dev/urandom | sudo tee nginx_default_build/html/rand_file_256K.txt >/dev/null
