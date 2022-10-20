#!/bin/bash
#set root directory
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build

#get global variables
source ${ROOT_DIR}/scripts/async_libsrcs.source

[ ! -f "${iperf_dir}/newreq.pem" ] || [ ! -f "${iperf_dir}/key.pem" ] && openssl req -x509 -newkey rsa:2048 -keyout ${iperf_dir}/key.pem -out ${iperf_dir}/newreq.pem -days 365 -nodes
cd ${iperf_dir}

#export LD_LIBRARY_PATH=${ktls_root}/openssl:$LD_LIBRARY_PATH
>&2 echo "[info] qtls iperf server..."
#ldd $ktls_iperf
#$ktls_iperf -c 192.168.1.1 -l262144 --tls --ktls --ktls_record_size=16000
sudo env OPENSSL_ENGINES=$QTLS_ENGINES \
	LD_LIBRARY_PATH=${ktls_root}/openssl:$LD_LIBRARY_PATH \
	$qtls_iperf -s -l262144 --tls
	#$qtls_iperf -h
