#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export LD_LIBRARY_PATH=${KTLS_OSSL}:${LD_LIBRARY_PATH}

MEM_S=$(( 1 * 1024 * 1024 ))
VSIZE=$(( 1 * 1024 ))
RES=tls_1LLCWay_${VSIZE}BRequests_$( echo "${MEM_S} / 1024 / 1024" | bc )GBSize_Uniform_Random
echo "results in ${RES}.csv"
ssh n869p538@pollux.ittc.ku.edu "/home/n869p538/intel/vtune/projects/nginx_profiling/memcached_profile.sh ${RES} "
vtune_pid=$!

sudo kill -s 2 $vtune_pid
exit

ssh n869p538@pollux.ittc.ku.edu "${ROOT_DIR}/scripts/kvs/tls_memcached.sh "
mem_pid=$!

$ROOT_DIR/scripts/kvs/tls_memory_antagonist_load.sh

ssh n869p538@pollux.ittc.ku.edu "/home/n869p538/intel/vtune/projects/nginx_profiling/memcached_profile.sh ${RES} "

$ROOT_DIR/scripts/kvs/tls_memory_antagonist_fetch.sh
ssh n869p538@pollux.ittc.ku.edu "sudo /opt/intel/oneapi/vtune/2022.4.0/bin64/vtune -r /home/n869p538/intel/vtune/projects/nginx_profiling/${RES} -command stop"
vtune_pid=$!

sudo kill -s 2 $mem_pid
sudo kill -s 2 $vtune_pid
