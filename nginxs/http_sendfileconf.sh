#!/bin/bash
>&2 echo "[info] http sendfile server ..."
[ "$(grep -e 'sendfile' ${DEFAULT_NGINX}/conf/nginx.conf)" = "" ] && sudo sed -i '/#optimizations/a sendfile\ton;' ${DEFAULT_NGINX}/conf/nginx.conf
sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${DEFAULT_NGINX}/conf/nginx.conf
sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/$masks/g" ${DEFAULT_NGINX}/conf/nginx.conf
sudo ${DEFAULT_NGINX_BIN}/nginx
