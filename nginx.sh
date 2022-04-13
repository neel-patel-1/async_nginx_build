#!/bin/bash

#set root directory
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

#get global variables
source ${ROOT_DIR}/scripts/async_libsrcs.source


#cores
if [ "$1" = "-s" ]; then
	cores=$3
else
	cores=$2
fi

total_cores=19
newMaskp1=""
newMaskp2=""
for i in `seq 1 $(($total_cores - $cores))`; do
    newMaskp1+="0"
    newMaskp2+="0"
done
for i in `seq 1 $((cores))`; do
    newMaskp1+="1"
    newMaskp2+="1"
done
newMaskp1+="0"
newMaskp2+="0"
>&2 echo "core mask: $newMaskp1$newMaskp2" 

	
#assume no engine, sendfile and change workers/coremask
if [ "$1" != "qtls" ]; then
	#>&2 echo "[info] default nginx will be used ..."
	sudo sed -i '/\s*ssl_engine\s*qatengine;/d' ${default_nginx_loc}/../conf/nginx.conf
	sudo sed -i '/\s*sendfile\s*on;/d' ${default_nginx_loc}/../conf/nginx.conf
	sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${default_nginx_loc}/../conf/nginx.conf
	sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/\1 $newMaskp1$newMaskp2\3/g" ${default_nginx_loc}/../conf/nginx.conf
else
	>&2 echo "qtls detected"
	cat $QTLS_NGINX/conf/nginx.conf
	exit
fi
	

if [ "$1" = "stop" ]; then
	ps aux | grep -e 'nginx:' | awk '{print $2}' | xargs sudo kill -s 2
elif [ "$1" = "tls" ]; then
	${ROOT_DIR}/nginxs/tls_conf.sh
	#>&2 echo "[info] https server... "
	#sudo sed -i '/ssl_engine qatengine;/d' ${default_nginx_loc}/../conf/nginx.conf
	#sudo sed -i '/#optimizations/a sendfile\ton;' ${default_nginx_loc}/../conf/nginx.conf
	#sudo ${default_nginx_loc}/nginx -t
	#sudo ${default_nginx_loc}/nginx
elif [ "$1" = "tlso" ]; then
	>&2 echo "[info] offload AXDIMM emulation https server..."
	sudo $DEFAULT_NGINX_BUILD/sbin/nginx -t
	sudo sed -i '/pid/a ssl_engine qatengine;' $DEFAULT_NGINX_BUILD/conf/nginx.conf
	sudo sed -i '/\s*sendfile\s*on;/d' $DEFAULT_NGINX_BUILD/conf/nginx.conf

	#export OPENSSL_ENGINES=$OPENSSL_OFFLOAD_LIB/engines-1.1
	#export LD_FLAGS="-L$OPENSSL_OFFLOAD"
	#export LD_LIBRARY_PATH=$OPENSSL_OFFLOAD:/home/n869p538/crypto_mb/2020u3/lib:/home/n869p538/intel-ipsec-mb/lib
	#echo "$OPENSSL_ENGINES:$LD_FLAGS:$LD_LIBRARY_PATH"
	#sudo $DEFAULT_NGINX_BUILD/sbin/nginx
	sudo env \
	OPENSSL_ENGINES=$OPENSSL_OFFLOAD_LIB/engines-1.1 \
	LD_FLAGS="-L$OPENSSL_OFFLOAD" \
	LD_LIBRARY_PATH=$OPENSSL_OFFLOAD_LIB/engines-1.1:$OPENSSL_OFFLOAD_LIB:$CRYPTOMB_INSTALL_DIR/lib:$IPSEC_INSTALL_LIB:$LD_LIBRARY_PATH \
	$DEFAULT_NGINX_BUILD/sbin/nginx
	#$OPENSSL_OFFLOAD/apps/openssl version
	#$OPENSSL_OFFLOAD/apps/openssl engine -t -c -v qatengine
	#openssl engine -t -c -v qatengine
elif [ "$1" = "qtls" ]; then
	>&2 echo "qtls offload tls"
	sudo ${QTLS_NGINX_BIN}/nginx -t #test qtls config

	sudo env \
	OPENSSL_ENGINES=$OPENSSL_LIBS/engines-1.1 \
	LD_FLAGS="-L$OPENSSL_LIB" \
	LD_LIBRARY_PATH=$OPENSSL_LIB:/home/n869p538/crypto_mb/2020u3/lib:/home/n869p538/intel-ipsec-mb/lib \
	${QTLS_NGINX_BIN}/nginx #start qtls config
	#$OPENSSL_LIB/bin/openssl engine -t -c -v qatengine # for debugging the engine
elif [ "$1" = "status" ]; then
	netstat -lan --numeric-ports | grep -e ':443\|:80'
elif [ "$1" = "-s" ]; then
	>&2 echo "[info] Provided argument passed to both nginx servers ..."
	sudo sed -i '/ssl_engine qatengine;/d' ${default_nginx_loc}/../conf/nginx.conf
	sudo ${default_nginx_loc}/nginx ${1} ${2} 2> >(grep pid)
	sudo ${qtls_nginx_loc}/nginx ${1} ${2} 2> >(grep pid)
else
	>&2 echo "UNKOWN OPERATION"
fi
