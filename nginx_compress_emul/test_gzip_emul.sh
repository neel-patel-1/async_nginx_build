#!/bin/bash
NGINX_VERSION=1.23.1
sudo rm -rf nginx_gzip_build
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar xzf nginx-${NGINX_VERSION}.tar.gz
cp nginx-${NGINX_VERSION}/configure nginx-gzip_offload
cd nginx-gzip_offload
./configure --prefix=$(pwd)/../nginx_gzip_build
make -j 30
make -j 30 install 
cd ../
sudo cp nginx.conf nginx_gzip_build/conf
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sudo ./nginx_gzip_build/sbin/nginx
f_sz=( "4K" "16K" "32K" )
for i in "${f_sz[@]}"; do
	head -c ${i} < /dev/urandom | sudo tee nginx_gzip_build/html/rand_file_${i}.txt >/dev/null
done
