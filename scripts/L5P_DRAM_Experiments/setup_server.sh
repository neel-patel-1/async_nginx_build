#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "$DEFAULT_DIR" ] && mkdir $DEFAULT_DIR
cd $DEFAULT_DIR

cd ${DEFAULT_DIR}

[ ! -f "${DEFAULT_DIR}/openssl-3.0.0.tar.gz" ] || [ ! -d "${DEFAULT_DIR}/openssl-3.0.0" ] ||\
	[ ! -f "${DEFAULT_DIR}/nginx-1.21.4.tar.gz" ] || [ ! -d "${DEFAULT_DIR}/nginx-1.21.4" ] ||\
	[ ! -f "${DEFAULT_DIR}/nginx_build/sbin/nginx" ] || [ ! -d "${DEFAULT_DIR}/nginx_build" ] \
	&& echo "File server requires nginx server build" 

FS_SIZE=$(( 1 * 1024 * 1024 * 1024 ))
FSZ=$(( 1 * 1024 ))
size=1K

sudo mount -t tmpfs -o size=1g tmpfs ${DEFAULT_DIR}/nginx_build/html
parallel dd if=/dev/random of=${DEFAULT_DIR}/nginx_build/html/UCFile_${size}_{}.txt bs=100 count=10 ::: {0..36608}
exit
for i in `seq 0 $(( FS_SIZE / FSZ )) `; do
	[ ! -f "${DEFAULT_DIR}/nginx_build/html/UCFile_${size}_$i.txt" ] && head -c $size < /dev/urandom | sudo tee ${DEFAULT_DIR}/nginx_build/html/UCFile_${size}_$i.txt > /dev/null
	#[ ! -f "${KTLS_NGINX}/html/UCFile_$i.txt" ] && head -c $size < /dev/urandom | sudo tee ${KTLS_NGINX}/html/UCFile_$i.txt > /dev/null
	#[ ! -f "${AXDIMM_NGINX}/html/UCFile_$i.txt" ] && head -c $size < /dev/urandom | sudo tee ${AXDIMM_NGINX}/html/UCFile_$i.txt > /dev/null
done
