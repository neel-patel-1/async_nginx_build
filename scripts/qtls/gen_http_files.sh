#!/bin/bash

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source


[[ ! -d "$ROOT_DIR/html_files" ]] && mkdir $ROOT_DIR/html_files


cd $ROOT_DIR/html_files

declare -a sizes=("256K" "4K" "16K" "64K" "128K")

for size in "${sizes[@]}";
do
	#echo $size
	head -c $size < /dev/urandom > file_$size.txt
done

[[ -d "$DEFAULT_NGINX_BUILD" ]] && sudo cp -r $ROOT_DIR/html_files/* $DEFAULT_NGINX_BUILD/html
[[ -d "$NGINX_INSTALL_DIR" ]] && sudo cp -r $ROOT_DIR/html_files/* $NGINX_INSTALL_DIR/html
