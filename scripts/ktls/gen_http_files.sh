#!/bin/bash

export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source


[[ ! -d "$ROOT_DIR/html_files" ]] && mkdir $ROOT_DIR/html_files


cd $ROOT_DIR/html_files

declare -a sizes=("256K" "4K" "16K" "64K" "128K" "1M" "2M" )

for size in "${sizes[@]}";
do
	#echo $size
	head -c $size < /dev/urandom > file_$size.txt
done

[[ -d "$KTLS_NGINX" ]] && sudo cp -r $ROOT_DIR/html_files/* $KTLS_NGINX/html

[[ ! -d "$ROOT_DIR/files_files" ]] && mkdir $ROOT_DIR/files_files


cd $ROOT_DIR/files_files

export f_size=$( cat /sys/devices/system/cpu/cpu0/cache/index3/size )
export num_rand=3

for i in `seq 1 $num_rand`; do
	head -c $f_size < /dev/urandom > file_$i.txt
done

[[ -d "$KTLS_NGINX" ]] && sudo cp -r $ROOT_DIR/files_files $KTLS_NGINX/files
