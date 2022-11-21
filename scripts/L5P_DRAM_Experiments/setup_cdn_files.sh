#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

declare -A sizes=( ["512"]=100 ["1K"]=100 ["1536"]=100 ["2K"]=50 ["3K"]=150 ["5K"]=100 ["8K"]=100 ["10K"]=75 ["13K"]=75 ["17K"]=50 ["25K"]=50 ["30K"]=10 ["60K"]=10 ["1M"]=10 ["10M"]=10 ["60M"]=10 )

[ ! -d "${ROOT_DIR}/CDN_FILES" ] && mkdir ${ROOT_DIR}/CDN_FILES
ctr=0
for s in "${!sizes[@]}"; do
	for c in `seq ${sizes[$s]}`; do
		[ ! -f "${ROOT_DIR}/CDN_FILES/UCFile_12345K_${ctr}.txt" ] && head -c $s < /dev/urandom > ${ROOT_DIR}/CDN_FILES/UCFile_12345K_${ctr}.txt
		ctr=$(( ctr + 1 ))
	done
done

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
while [ ! -z "$( mount | grep $ACCEL_GZIP_FILE_DIR)" ];
do
	sudo umount -f $ACCEL_GZIP_FILE_DIR
done

sudo mount -t tmpfs -o size=1g tmpfs ${DEFAULT_DIR}/nginx_build/html
sudo mount -t tmpfs -o size=1g tmpfs $AXDIMM_NGINX/html
sudo mount -t tmpfs -o size=1g tmpfs $KTLS_NGINX/html
sudo mount -t tmpfs -o size=1g tmpfs $QTLS_NGINX/html
sudo mount -t tmpfs -o size=1g tmpfs $QTLS_NGINX/html
sudo mount -t tmpfs -o size=1g tmpfs $ACCEL_GZIP_FILE_DIR

cp -r ${ROOT_DIR}/CDN_FILES/* ${DEFAULT_DIR}/nginx_build/html
cp -r ${ROOT_DIR}/CDN_FILES/* ${AXDIMM_DIR}/nginx_build/html
cp -r ${ROOT_DIR}/CDN_FILES/* ${KTLS_NGINX}/html
cp -r ${ROOT_DIR}/CDN_FILES/* ${QTLS_NGINX}/html
cp -r ${ROOT_DIR}/CDN_FILES/* $ACCEL_GZIP_FILE_DIR
