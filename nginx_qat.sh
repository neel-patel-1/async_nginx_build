#!/bin/bash

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source ${ROOT_DIR}/scripts/async_libsrcs.source
export nginx_loc=$DEFAULT_NGINX_BUILD/sbin
export qtls_nginx_loc=$NGINX_INSTALL_DIR/sbin
export nginx_conf_loc=${ROOT_DIR}/default_nginx_conf/nginx.conf

export OPENSSL_ENGINES=$OPENSSL_LIBS/engines-1.1
export LD_FLAGS="-L$OPENSSL_INSTALL" 
export LD_LIBRARY_PATH=$OPENSSL_LIBS:/home/n869p538/crypto_mb/2020u3/lib:/home/n869p538/intel-ipsec-mb/lib

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
	>&2 echo "[info] default nginx will be used ..."
	sudo sed -i '/\s*ssl_engine\s*qatengine;/d' ${nginx_loc}/../conf/nginx.conf
	sudo sed -i '/\s*sendfile\s*on;/d' ${nginx_loc}/../conf/nginx.conf
	sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${nginx_loc}/../conf/nginx.conf
	sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/\1 $newMaskp1$newMaskp2\3/g" ${nginx_loc}/../conf/nginx.conf
else
	>&2 echo "qtls detected"
fi
	

if [ "$1" = "stop" ]; then
	sudo ${nginx_loc}/nginx -s stop
	sudo ${qtls_nginx_loc}/nginx -s stop
elif [ "$1" = "tls" ]; then
	>&2 echo "[info] https server... "
	sudo sed -i '/ssl_engine qatengine;/d' ${nginx_loc}/../conf/nginx.conf
	sudo sed -i '/#optimizations/a sendfile\ton;' ${nginx_loc}/../conf/nginx.conf
	sudo ${nginx_loc}/nginx -t
	sudo ${nginx_loc}/nginx
elif [ "$1" = "tlso" ]; then
	>&2 echo "[info] offload AXDIMM emulation https server..."
	sudo ${nginx_loc}/nginx -t
	sudo sed -i '/pid/a ssl_engine qatengine;' $DEFAULT_NGINX_BUILD/conf/nginx.conf
	sudo sed -i '/\s*sendfile\s*on;/d' $DEFAULT_NGINX_BUILD/conf/nginx.conf

	#export OPENSSL_ENGINES=/home/n869p538/ktls_client_server/openssl/openssl/lib/engines-1.1 
	#export LD_FLAGS="-L/home/n869p538/ktls_client_server/openssl/openssl"  
	#export LD_LIBRARY_PATH=/home/n869p538/ktls_client_server/openssl/openssl/lib:/home/n869p538/crypto_mb/2020u3/lib:/home/n869p538/intel-ipsec-mb/lib 
	#sudo /home/n869p538/nginx_build/sbin/nginx
	#sudo env
	export OPENSSL_ENGINES=$OPENSSL_OFFLOAD_LIB/engines-1.1
	export LD_FLAGS="-L$OPENSSL_OFFLOAD"
	export LD_LIBRARY_PATH=$OPENSSL_OFFLOAD:/home/n869p538/crypto_mb/2020u3/lib:/home/n869p538/intel-ipsec-mb/lib
	echo "$OPENSSL_ENGINES:$LD_FLAGS:$LD_LIBRARY_PATH"
	$DEFAULT_NGINX_BUILD/sbin/nginx
elif [ "$1" = "qtls" ]; then
	>&2 echo "qtls offload tls"
	sudo ${qtls_nginx_loc}/nginx -t #test qtls config
	sudo ${qtls_nginx_loc}/nginx #start qtls config
elif [ "$1" = "status" ]; then
	netstat -lan --numeric-ports | grep -e ':443\|:80'
elif [ "$1" = "-s" ]; then
	>&2 echo "[info] Provided argument passed to both nginx servers ..."
	sudo sed -i '/ssl_engine qatengine;/d' ${nginx_loc}/../conf/nginx.conf
	sudo ${nginx_loc}/nginx ${1} ${2} 2> >(grep pid)
	sudo ${qtls_nginx_loc}/nginx ${1} ${2} 2> >(grep pid)
else
	>&2 echo "UNKOWN OPERATION"
fi
