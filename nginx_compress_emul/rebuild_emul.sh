#!/bin/bash
sudo rm -rf nginx_gzip_build
cd nginx-gzip_offload
make -j 30
make -j 30 install 
cd ../
sudo cp nginx.conf nginx_gzip_build/conf
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sudo ./nginx_gzip_build/sbin/nginx
head -c 256K < /dev/urandom | sudo tee nginx_gzip_build/html/rand_file_256K.txt >/dev/null
