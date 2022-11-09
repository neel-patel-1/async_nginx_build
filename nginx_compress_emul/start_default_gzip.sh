#!/bin/bash
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sleep 0.3
sudo cp nginx_original.conf nginx_default_build/conf/nginx.conf

NCORES=10
sudo rdtset -r 1-$NCORES -t "l3=0x80;cpu=1-$NCORES" -c 1-$NCORES -k \
	./nginx_default_build/sbin/nginx
