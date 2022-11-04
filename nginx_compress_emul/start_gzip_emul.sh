#!/bin/bash
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sleep 0.3
if [ ! -z "$1" ]; then
	./mod_trim.sh $1
fi
sudo cp nginx_default.conf nginx_gzip_build/conf/nginx.conf
sudo ./nginx_gzip_build/sbin/nginx
