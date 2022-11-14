#!/bin/bash
>&2 echo "[info] https server... "
#turn off sendfile
sudo sed -i '/\s*sendfile\s*on;/d' $DEFAULT_NGINX/conf/nginx.conf

sudo cp -f ${ROOT_DIR}/default_nginx_conf/nginx.conf ${DEFAULT_NGINX}/conf/nginx.conf

if [ -z "$( grep worker_processes ${DEFAULT_NGINX}/conf/nginx.conf )" ]; then
	sudo sed -i -E "/number of cores/a worker_processes ${cores};" ${DEFAULT_NGINX}/conf/nginx.conf
else
	sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${DEFAULT_NGINX}/conf/nginx.conf
fi

if [ -z "$( grep worker_cpu_affinity ${DEFAULT_NGINX}/conf/nginx.conf )" ]; then
	sudo sed -i -E "/worker_processes/a $masks" ${DEFAULT_NGINX}/conf/nginx.conf
else
	sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/$masks/g" ${DEFAULT_NGINX}/conf/nginx.conf
fi


sudo ${DEFAULT_NGINX}/sbin/nginx -t
sudo pqos -R
sudo pqos -e "llc:1=0x0007;"
sudo pqos -a "llc:1=1-10;"
sudo ${DEFAULT_NGINX}/sbin/nginx
