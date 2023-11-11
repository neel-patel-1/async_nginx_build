#!/bin/bash
NGINX_VERSION=1.23.1

if [ ! -d "nginx-${NGINX_VERSION}" ]; then
	wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
	tar xzf nginx-${NGINX_VERSION}.tar.gz
fi

mkdir -p nginx_default_src && tar -xf nginx-1.23.1.tar.gz -C nginx_default_src --strip-components 1

if [ ! -d "nginx_default_build/sbin/nginx" ]; then
	cd nginx_default_src
	./configure --prefix=$(pwd)/../nginx_default_build
	make -j 30
	make -j 30 install 
	cd ../
fi

sudo cp ../gzip_nginx_conf/nginx.conf nginx_default_build/conf/nginx.conf
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sudo ./nginx_default_build/sbin/nginx

f_sz=( "4K" "16K" "32K" )
for i in "${f_sz[@]}"; do
	head -c ${i} < /dev/urandom | sudo tee nginx_default_build/html/rand_file_${i}.txt >/dev/null
	head -c ${i} < /dev/zero | sudo tee nginx_default_build/html/zero_file_${i}.txt >/dev/null
done
