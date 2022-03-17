#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source $ROOT_DIR/scripts/qtls_libs.src

if [ ! -d "${ROOT_DIR}/testdir" ]; then
	mkdir $ROOT_DIR/testdir
	cd ${ROOT_DIR}/testdir
	for i in `seq 1 10`; do

		touch file${1}.txt
		cat /dev/zero | head -c 1G > file${i}.txt

	done
fi

id -Gn

qzip -O 7z -k $ROOT_DIR/testdir -o $ROOT_DIR/testdirresult.7z

[ -d "${ROOT_DIR}/testdirresult.7z" ] && rm $ROOT_DIR/testdirresult.7z
