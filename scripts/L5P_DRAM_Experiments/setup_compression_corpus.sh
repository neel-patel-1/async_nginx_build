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

while [ ! -z "$( mount | grep ${DEFAULT_DIR}/nginx_build/html)" ];
do
	sudo umount -f ${DEFAULT_DIR}/nginx_build/html
done
while [ ! -z "$( mount | grep $QTLS_NGINX/html)" ];
do
	sudo umount -f $QTLS_NGINX/html
done
while [ ! -z "$( mount | grep $ACCEL_GZIP_FILE_DIR)" ];
do
	sudo umount -f $ACCEL_GZIP_FILE_DIR
done

FULL_SIZE=1K

# check sw compression ratio
parallel "cp ${ROOT_DIR}/comp_files/bbc_file_${FULL_SIZE}.html ${DEFAULT_DIR}/nginx_build/html/UCFILE_${FULL_SIZE}_{}.html" ::: {0..999}
${ROOT_DIR}/nginx.sh http 10
COMP_SIZE=$( wget --header="accept-encoding:gzip, deflate" http://localhost/UCFILE_${FULL_SIZE}_1.html  2>&1 | grep saved | awk '{print $6}' | sed -e 's/^.//' -e 's/.$//' | xargs du -b | awk '{print $1}' )

# emulate compression of entire file length on SmartDIMM
TRIM_CONF=${ROOT_DIR}/nginx_compress_emul/nginx_default.conf
sed -i -E "s/file_length [0-9]+;/file_length ${FULL_SIZE};/g" ${TRIM_CONF}

sudo mount -t tmpfs -o size=1g tmpfs ${DEFAULT_DIR}/nginx_build/html
sudo mount -t tmpfs -o size=1g tmpfs $QTLS_NGINX/html
sudo mount -t tmpfs -o size=1g tmpfs $ACCEL_GZIP_FILE_DIR

parallel "head -c ${COMP_SIZE} < /dev/zero > $ACCEL_GZIP_FILE_DIR/UCFILE_${FULL_SIZE}_{}.html" ::: {0..999}

parallel "cp ${ROOT_DIR}/comp_files/bbc_file_${FULL_SIZE}.html ${DEFAULT_DIR}/nginx_build/html/UCFILE_${FULL_SIZE}_{}.html" ::: {0..999}
parallel "cp ${ROOT_DIR}/comp_files/bbc_file_1K.html ${QTLS_NGINX}/html/UCFILE_${FULL_SIZE}_{}.html" ::: {0..999}
