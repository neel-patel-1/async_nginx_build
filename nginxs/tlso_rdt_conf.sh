#!/bin/bash
>&2 echo "[info] AXDIMM server..."
sudo env \
OPENSSL_ENGINES=$AXDIMM_ENGINES \
LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_DIR/lib \
$AXDIMM_NGINX/sbin/nginx -t
#do we need to add crypto_mb to the path -- the engine is not linked against it

#copy nginx.conf to tgt
sudo cp -f ${ROOT_DIR}/axdimm_nginx_confs/nginx.conf ${AXDIMM_NGINX}/conf/nginx.conf

if [ -z "$( grep worker_processes ${AXDIMM_NGINX}/conf/nginx.conf )" ]; then
	sudo sed -i "/number of cores/a worker_processes ${cores};" ${AXDIMM_NGINX}/conf/nginx.conf
else
	sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${AXDIMM_NGINX}/conf/nginx.conf
fi

if [ -z "$( grep worker_cpu_affinity ${AXDIMM_NGINX}/conf/nginx.conf )" ]; then
	sudo sed -i "/worker_processes/a $masks" ${AXDIMM_NGINX}/conf/nginx.conf
else
	sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/$masks/g" ${AXDIMM_NGINX}/conf/nginx.conf
fi


#LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_DIR/intel-ipsec-mb/lib \
sudo env \
OPENSSL_ENGINES=$AXDIMM_ENGINES \
LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_DIR/lib \
rdtset -k -r 1-${cores} -t "l3=0x20000;cpu=0-${cores}" -c 1-${cores} ${AXDIMM_NGINX}/sbin/nginx
