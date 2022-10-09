#!/bin/bash
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
head -c 256K < /dev/urandom | sudo tee nginx_gzip_build/html/rand_file_256K.txt >/dev/null
sudo ./nginx_gzip_build/sbin/nginx
