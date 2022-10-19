#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "$ROOT_DIR/kv_bench" ] && mkdir $ROOT_DIR/kv_bench
cd $ROOT_DIR/kv_bench
sudo rm -rf $ROOT_DIR/kv_bench/memtier_build

[ ! -d "memtier_benchmark" ] && git clone --branch 1.3.0 --depth 1 https://github.com/RedisLabs/memtier_benchmark.git
cd memtier_benchmark

if [ ! -f "$memtier_bin" ]; then
	autoreconf -ivf
	#env \
	#LDFLAGS="-L${KTLS_OSSL}" \
	#LIBS="-lcrypto -lssl" \
	./configure --prefix=$memtier_build_dir
	make -j 4
	sudo make install -j 4
fi
