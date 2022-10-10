#!/bin/bash
#set root directory
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build

#get global variables
source ${ROOT_DIR}/scripts/async_libsrcs.source

[ ! -f "${iperf_dir}/newreq.pem" ] || [ ! -f "${iperf_dir}/key.pem" ] && openssl req -x509 -newkey rsa:2048 -keyout ${iperf_dir}/key.pem -out ${iperf_dir}/newreq.pem -days 365 -nodes
cd ${iperf_dir}

>&2 echo "[info] ktls iperf server..."
$ktls_iperf --tls=v1.2 -s
