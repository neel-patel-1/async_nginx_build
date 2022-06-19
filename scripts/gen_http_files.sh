#!/bin/bash

export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

size=${1}

for i in "${all_nginxs[@]}"; do
	if [ ! -f "${!i}/html/file_${size}" ]; then
		>&2 echo "adding file_${size} to ${i}"
		head -c $size < /dev/urandom > file_$size.txt
	else
		>&2 echo "file_${size} already present in ${i}"
	fi	
done
