#!/bin/bash
>&2 echo "[info] https server... "
sudo sed -i '/ssl_engine qatengine;/d' ${default_nginx_loc}/../conf/nginx.conf
sudo sed -i '/#optimizations/a sendfile\ton;' ${default_nginx_loc}/../conf/nginx.conf
sudo ${default_nginx_loc}/nginx -t
sudo ${default_nginx_loc}/nginx
