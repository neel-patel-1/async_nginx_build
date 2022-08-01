#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source


[ ! -d "$ROOT_DIR/kv_bench" ] && mkdir $ROOT_DIR/kv_bench
cd $ROOT_DIR/kv_bench

[ ! -d "memtier_offload_support" ] && git clone --depth 1 git@github.com:neelpatelbiz/memtier_offload_support.git
cd memtier_offload_support

if [ ! -f "$offload_memtier_bin" ]; then
	autoreconf -ivf
	./configure --prefix=$(pwd)/../offload_memtier_build
	make -j 4
	sudo make install -j 4
else
	autoreconf -ivf
	./configure --prefix=$(pwd)/../offload_memtier_build
	make -j 4
	sudo make install -j 4
fi
