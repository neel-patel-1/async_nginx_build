#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export LD_LIBRARY_PATH=${KTLS_OSSL}:${LD_LIBRARY_PATH}

MEM_S=$(( 1 * 1024 * 1024 * 1024 ))
VSIZE=$(( 1 * 1024 ))
SET_P="--ratio=0:1 --key-pattern=S:S"
EXTRA="--hide-histogram"
KEY_RANGE="--key-minimum=200 --key-maximum=$(( 200 + (MEM_S / VSIZE) )) -n allkeys"
DATA=" --random-data --data-size=${VSIZE}"

${memtier_bin} --tls --tls-skip-verify -s ${remote_mem_ip} -p 5002 -t 4 -P memcache_text $DATA $SET_P $EXTRA $KEY_RANGE