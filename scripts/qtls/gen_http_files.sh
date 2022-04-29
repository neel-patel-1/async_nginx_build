#!/bin/bash

export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source


[[ ! -d "$ROOT_DIR/html_files" ]] && mkdir $ROOT_DIR/html_files


cd $ROOT_DIR/html_files

declare -a sizes=("256K" "4K" "16K" "64K" "128K" "1M" "2M" )

for size in "${sizes[@]}";
do
	#echo $size
	head -c $size < /dev/urandom > file_$size.txt
done

[[ -d "$QTLS_NGINX" ]] && sudo cp -r $ROOT_DIR/html_files/* $QTLS_NGINX/html
