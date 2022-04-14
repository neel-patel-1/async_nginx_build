#!/bin/bash
>&2 echo "[info] https server... "
sudo sed -i '/\s*sendfile\s*on;/d' $DEFAULT_NGINX/conf/nginx.conf
sudo sed -i '/ssl_engine qatengine;/d' ${DEFAULT_NGINX}/conf/nginx.conf
sudo sed -i '/#optimizations/a sendfile\ton;' ${DEFAULT_NGINX}/conf/nginx.conf
sudo ${DEFAULT_NGINX}/sbin/nginx -t
sudo ${DEFAULT_NGINX}/sbin/nginx
