#!/bin/bash

export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

size=${1}

for i in "${all_nginxs[@]}"; do
	if [ ! -f "${!i}/html/file_${size}.txt" ]; then
		>&2 echo "adding file_${size} to ${i}"
		head -c $size < /dev/urandom | sudo tee ${!i}/html/file_$size.txt >/dev/null
	else
		>&2 echo "file_${size} already present in ${i}"
	fi	
done
