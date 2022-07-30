#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "$ROOT_DIR/kv_bench" ] && mkdir $ROOT_DIR/kv_bench
cd $ROOT_DIR/kv_bench

[ ! -d "mc-crusher" ] && git clone https://github.com/memcached/mc-crusher.git \
       && cd mc-crusher && git reset --hard 7ca3f14c128495a509cd0aaff464545377fa5cee

cd $mc_bench_dir
[ ! -f "$mc_bench_bin" ] && make tls -j 4 
