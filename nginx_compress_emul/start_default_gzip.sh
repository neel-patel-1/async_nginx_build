#!/bin/bash
ps aux | grep nginx | awk '{print $2}' | xargs sudo kill -s 2
sleep 0.3
sudo cp nginx_original.conf nginx_default_build/conf/nginx.conf
sudo ./nginx_default_build/sbin/nginx
