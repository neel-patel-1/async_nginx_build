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

#parallel "head -c ${size} < /dev/zero > ${DEFAULT_DIR}/nginx_build/html/UCFile_${size}_{}.txt" ::: {0..399}

while [ ! -z "$( mount | grep ${DEFAULT_DIR}/nginx_build/html)" ];
do
	sudo umount -f ${DEFAULT_DIR}/nginx_build/html
done
while [ ! -z "$( mount | grep $AXDIMM_NGINX/html)" ];
do
	sudo umount -f $AXDIMM_NGINX/html
done
while [ ! -z "$( mount | grep $KTLS_NGINX/html)" ];
do
	sudo umount -f $KTLS_NGINX/html
done
while [ ! -z "$( mount | grep $QTLS_NGINX/html)" ];
do
	sudo umount -f $QTLS_NGINX/html
done

sudo mount -t tmpfs -o size=1g tmpfs ${DEFAULT_DIR}/nginx_build/html
sudo mount -t tmpfs -o size=1g tmpfs $AXDIMM_NGINX/html
sudo mount -t tmpfs -o size=1g tmpfs $KTLS_NGINX/html
sudo mount -t tmpfs -o size=1g tmpfs $QTLS_NGINX/html
sudo mount -t tmpfs -o size=1g tmpfs $QTLS_NGINX/html
sudo mount -t tmpfs -o size=1g tmpfs $ACCEL_GZIP_FILE_DIR

[ ! -z "${1}" ] && [ ! -z "${2}" ] && \
	parallel "head -c ${1} < /dev/urandom > ${ROOT_DIR}/comp_files/UCFile_${1}_{}.txt" ::: {0..999} && \
	cp -r ${ROOT_DIR}/comp_files/UCFile_${1}* ${DEFAULT_DIR}/nginx_build/html && \
	cp -r ${ROOT_DIR}/comp_files/UCFile_${1}* ${AXDIMM_DIR}/nginx_build/html && \
	cp -r ${ROOT_DIR}/comp_files/UCFile_${1}* ${KTLS_NGINX}/html && \
	cp -r ${ROOT_DIR}/comp_files/UCFile_${1}* ${QTLS_NGINX}/html && \
	cp -r ${ROOT_DIR}/comp_files/UCFile_${1}* $ACCEL_GZIP_FILE_DIR
