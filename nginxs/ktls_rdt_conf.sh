#!/bin/bash
>&2 echo "[info] ktls sendfile server... "

sudo cp -f ${ROOT_DIR}/ktls_nginx_conf/nginx.conf ${KTLS_NGINX}/conf/nginx.conf

if [ -z "$( grep worker_processes ${KTLS_NGINX}/conf/nginx.conf )" ]; then
	sudo sed -i -E "/number of cores/a worker_processes ${cores};" ${KTLS_NGINX}/conf/nginx.conf
else
	sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${KTLS_NGINX}/conf/nginx.conf
fi

if [ -z "$( grep worker_cpu_affinity ${KTLS_NGINX}/conf/nginx.conf )" ]; then
	sudo sed -i -E "/worker_processes/a $masks" ${KTLS_NGINX}/conf/nginx.conf
else
	sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/$masks/g" ${KTLS_NGINX}/conf/nginx.conf
fi

sudo ${KTLS_NGINX}/sbin/nginx -t
sudo rdtset -r 1-${cores} -t "l3=0x20000;cpu=0-${cores}" -c 1-${cores} ${KTLS_NGINX}/nginx
