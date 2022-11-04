#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export LD_LIBRARY_PATH=${KTLS_OSSL}:${LD_LIBRARY_PATH}

L_CORES=( "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" )

for i in "${L_CORES[@]}"; do
	taskset -c ${i} ${memtier_bin} --tls --tls-skip-verify -s ${remote_mem_ip} -p 5002 --threads=1 -c 64 --data-size=32 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=1:0 --hide-histogram --out-file /dev/null &
done
wait

for i in "${L_CORES[@]}"; do
	taskset -c ${i} ${memtier_bin} --tls --tls-skip-verify -s ${remote_mem_ip} -p 5002 --threads=1 -c 64 -P memcache_text --key-pattern=S:S  --data-size=32 --key-minimum=1 --key-maximum=50 --ratio=0:1 --hide-histogram --out-file Memtier_LCore_${i} &
done
grep Total Memtier_LCore_* | awk '{print $2}' | awk '{sum+=$1} END{print sum}'
#cat tls_test.txt | sed -E 's/\s+/,/g' | grep -vE '(=|--------)'

exit
${memtier_bin} --tls --tls-skip-verify -s ${remote_mem_ip} -p 5002 -t 4 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=1:0 --hide-histogram --out-file tls_test.txt

${memtier_bin} --tls --tls-skip-verify -s ${remote_mem_ip} -p 5002 -t 4 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=1:1 --hide-histogram --out-file tls_test.txt

cat tls_test.txt | sed -E 's/\s+/,/g' | grep -vE '(=|--------)'

