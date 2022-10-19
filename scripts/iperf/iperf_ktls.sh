#!/bin/bash
#set root directory
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build

#get global variables
source ${ROOT_DIR}/scripts/async_libsrcs.source

[ ! -f "${iperf_dir}/newreq.pem" ] || [ ! -f "${iperf_dir}/key.pem" ] && openssl req -x509 -newkey rsa:2048 -keyout ${iperf_dir}/key.pem -out ${iperf_dir}/newreq.pem -days 365 -nodes
cd ${iperf_dir}

export LD_LIBRARY_PATH=/home/n869p538/wrk_offloadenginesupport/client_wrks/autonomous-asplos21-artifact/openssl:$LD_LIBRARY_PATH
>&2 echo "[info] ktls iperf server..."
#ldd $ktls_iperf
#$ktls_iperf -c 192.168.1.1 -l262144 --tls --ktls --ktls_record_size=16000
$ktls_iperf -s -l262144 --tls --ktls 
#$ktls_iperf -s -X
