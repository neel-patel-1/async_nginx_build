#!/bin/bash
>&2 echo "[info] SmartDIMM Gzip server ..."

sudo cp -f ${ROOT_DIR}/SmartDIMM_gzip_nginx_conf/nginx_default.conf ${ACCEL_GZIP_NGINX_CONF}

if [ -z "$( grep worker_processes ${ACCEL_GZIP_NGINX_CONF} )" ]; then
	sudo sed -i -E "/number of cores/a worker_processes ${cores};" ${ACCEL_GZIP_NGINX_CONF}
else
	sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${ACCEL_GZIP_NGINX_CONF}
fi

if [ -z "$( grep worker_cpu_affinity ${ACCEL_GZIP_NGINX_CONF} )" ]; then
	sudo sed -i -E "/worker_processes/a $masks" ${ACCEL_GZIP_NGINX_CONF}
else
	sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/$masks/g" ${ACCEL_GZIP_NGINX_CONF}
fi
	
sudo $ACCEL_GZIP_NGINX -t
sudo pqos -R
sudo pqos -e "llc:1=0x0007;"
sudo pqos -a "llc:1=1-10;"
sudo $ACCEL_GZIP_NGINX
