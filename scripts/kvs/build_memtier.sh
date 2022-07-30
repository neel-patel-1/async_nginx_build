#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source


[ ! -d "$ROOT_DIR/kv_bench" ] && mkdir $ROOT_DIR/kv_bench
cd $ROOT_DIR/kv_bench

[ ! -d "memtier_benchmark" ] && git clone --branch 1.3.0 --depth 1 https://github.com/RedisLabs/memtier_benchmark.git
cd memtier_benchmark
if [ ! -f "$ROOT_DIR/memtier_build/bin/memtier_benchmark" ]; then
	autoreconf -ivf
	./configure --prefix=$ROOT_DIR/memtier_build
	make -j 4
	make install -j 4
fi
