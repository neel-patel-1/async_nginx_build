#!/bin/bash

#set root directory
export ROOT_DIR=/home/n869p538/async_nginx_build

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
export cores
export newMaskp1
export newMaskp2

	

ps aux | grep -e 'nginx:' | awk '{print $2}' | xargs sudo kill -s 2
if [ "$1" = "stop" ]; then
	ps aux | grep -e 'nginx:' | awk '{print $2}' | xargs sudo kill -s 2
elif [ "$1" = "http" ]; then
	${ROOT_DIR}/nginxs/http_conf.sh
elif [ "$1" = "httpsendfile" ]; then
	${ROOT_DIR}/nginxs/http_sendfileconf.sh
elif [ "$1" = "https" ]; then
	${ROOT_DIR}/nginxs/tls_conf.sh
elif [ "$1" = "axdimm" ]; then
	${ROOT_DIR}/nginxs/tlso_conf.sh
elif [ "$1" = "qtls" ]; then
	${ROOT_DIR}/nginxs/qtls_conf.sh
else
	>&2 echo "UNKOWN OPERATION"
fi
