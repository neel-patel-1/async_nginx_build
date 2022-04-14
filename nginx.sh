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
elif [ "$1" = "http" ]; then
	${ROOT_DIR}/nginxs/http_conf.sh
elif [ "$1" = "http_sendfile" ]; then
	${ROOT_DIR}/nginxs/tls_conf.sh
elif [ "$1" = "https" ]; then
	${ROOT_DIR}/nginxs/tls_conf.sh
elif [ "$1" = "axdimm" ]; then
	${ROOT_DIR}/nginxs/tlso_conf.sh
elif [ "$1" = "qtls" ]; then
	${ROOT_DIR}/nginxs/qtls_conf.sh
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
