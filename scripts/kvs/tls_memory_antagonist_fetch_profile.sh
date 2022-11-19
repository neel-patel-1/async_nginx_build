#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export LD_LIBRARY_PATH=${KTLS_OSSL}:${LD_LIBRARY_PATH}

N_OPS=100000
MEM_S=${1}
VSIZE=${2}
TDS=${3}
CLIS=${4}

[ -z "${1}" ] && MEM_S=$(( 5 * 1024 * 1024 * 1024 ))
[ -z "${2}" ] && VSIZE=$(( 1 * 1024 ))
[ -z "${3}" ] && TDS=10
[ -z "${4}" ] && CLIS=50

SET_P="--ratio=0:1 --key-pattern=R:R"
EXTRA="--hide-histogram"
KEY_RANGE="--key-minimum=200 --key-maximum=$(( 200 + (MEM_S / VSIZE) ))"
DATA=" --data-size=${VSIZE}"
TD_CLI_OPS="-t $TDS -c $CLIS -n ${N_OPS}" #$(( N_OPS / (TDS * CLIS) ))"

${memtier_bin} --tls --tls-skip-verify -s ${remote_mem_ip} -p 5002 -P memcache_text $SET_P $EXTRA $KEY_RANGE $TD_CLI_OPS
