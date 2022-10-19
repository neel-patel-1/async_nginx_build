#!/bin/bash
>&2 echo "[info] qtls server ..."
sudo env \
OPENSSL_ENGINES=$OPENSSL_LIBS/engines-1.1 \
LD_LIBRARY_PATH=$OPENSSL_LIB:~/home/n869p538/ssl_balancers/QATzip/src \
${QTLS_NGINX_BIN}/nginx -t #test qtls config

sudo cp -f ${ROOT_DIR}/async_nginx_conf/nginx.conf_no_gzip ${QTLS_NGINX}/conf/nginx.conf

if [ -z "$( grep worker_processes ${QTLS_NGINX}/conf/nginx.conf )" ]; then
	sudo sed -i "/number of cores/a worker_processes ${cores};" ${QTLS_NGINX}/conf/nginx.conf
else
	sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${QTLS_NGINX}/conf/nginx.conf
fi

if [ -z "$( grep worker_cpu_affinity ${QTLS_NGINX}/conf/nginx.conf )" ]; then
	sudo sed -i -E "/worker_processes/a $cores" ${QTLS_NGINX}/conf/nginx.conf
else
	sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/$masks/g" ${QTLS_NGINX}/conf/nginx.conf
fi

sudo env \
OPENSSL_ENGINES=$OPENSSL_LIBS/engines-1.1 \
LD_LIBRARY_PATH=$OPENSSL_LIB \
${QTLS_NGINX_BIN}/nginx 
