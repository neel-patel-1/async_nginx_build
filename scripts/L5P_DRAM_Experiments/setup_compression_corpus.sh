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

if [ ! -z "${1}" ]; then
	FULL_SIZE=${1}
else
	FULL_SIZE=1K
fi

mb_p='([0-9][0-9]*\.?[0-9]*)(B|K|M|G)'
if [[ ${FULL_SIZE} =~ $mb_p ]] && [[ ${BASH_REMATCH[2]} == "M" ]] ; then
	FULL_SIZE_BYTES=$(python -c "print(${BASH_REMATCH[1]} * 1024 * 1024 )")
elif [[ ${FULL_SIZE} =~ $mb_p ]] && [[ ${BASH_REMATCH[2]} == "K" ]] ; then
	FULL_SIZE_BYTES=$(python -c "print(${BASH_REMATCH[1]} * 1024  )")
	#echo "MBMATCH:${BASH_REMATCH[1]}"
elif [[ ${FULL_SIZE} =~ $mb_p ]] && [[ ${BASH_REMATCH[2]} == "G" ]] ; then
	FULL_SIZE_BYTES=$(python -c "print(${BASH_REMATCH[1]} * 1024 * 1024 * 1024 )")
else
	FULL_SIZE_BYTES=${BASH_REMATCH[1]}
fi

TRIM_CONF=${ROOT_DIR}/SmartDIMM_gzip_nginx_conf/nginx_default.conf

# check sw compression ratio and populate default dir
mkdir -p ${ROOT_DIR}/comp_files
[ ! -f "${ROOT_DIR}/comp_files/bbc_file.html" ] && curl bbc.co.uk --output ${ROOT_DIR}/comp_files/bbc_file.html
#[ ! -f "${ROOT_DIR}/comp_files/file.txt" ] && curl bbc.co.uk --output ${ROOT_DIR}/comp_files/bbc_file.html
[ ! -f "${ROOT_DIR}/comp_files/bbc_file_${FULL_SIZE}.html" ] && head -c ${FULL_SIZE} < ${ROOT_DIR}/comp_files/bbc_file.html > ${ROOT_DIR}/comp_files/bbc_file_${FULL_SIZE}.html
sudo mount -t tmpfs -o size=1g tmpfs ${DEFAULT_DIR}/nginx_build/html
sudo mount -t tmpfs -o size=1g tmpfs $QTLS_NGINX/html
parallel "cp ${ROOT_DIR}/comp_files/bbc_file_${FULL_SIZE}.html ${DEFAULT_DIR}/nginx_build/html/UCFile_${FULL_SIZE}_{}.txt" ::: {0..999}
parallel "cp ${ROOT_DIR}/comp_files/bbc_file_${FULL_SIZE}.html ${QTLS_NGINX}/html/UCFile_${FULL_SIZE}_{}.txt" ::: {0..999}
#cp ${ROOT_DIR}/comp_files/file.txt ${QTLS_NGINX}/html
#cp ${ROOT_DIR}/comp_files/calgary.txt ${QTLS_NGINX}/html
#exit
${ROOT_DIR}/nginx.sh http_gzip 10
COMP_SIZE=$( wget --header="accept-encoding:gzip, deflate" http://localhost/UCFile_${FULL_SIZE}_1.txt  2>&1 | grep saved | awk '{print $6}' | sed -e 's/^.//' -e 's/.$//' | xargs du -b | awk '{print $1}' )

# emulate compression of entire file length on SmartDIMM
sed -i -E "s/file_length [0-9]+;/file_length ${FULL_SIZE_BYTES};/g" ${TRIM_CONF}
${ROOT_DIR}/nginx.sh accel_gzip 10

# populate accel and qat
sudo mount -t tmpfs -o size=1g tmpfs $ACCEL_GZIP_FILE_DIR

parallel "head -c ${COMP_SIZE} < ${ROOT_DIR}/comp_files/bbc_file.html > $ACCEL_GZIP_FILE_DIR/UCFile_${FULL_SIZE}_{}.txt" ::: {0..999}
