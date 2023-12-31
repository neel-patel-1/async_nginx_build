#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

${memtier_bin} -s ${remote_mem_ip} -p 5002 -t 4 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=1:0 --hide-histogram

${memtier_bin} -s ${remote_mem_ip} -p 5002 -t 4 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=1:1 --hide-histogram --out-file tcp_test.txt

cat tcp_test.txt | sed -E 's/\s+/,/g' | grep -vE '(=|--------)'

${memtier_bin} -s ${remote_mem_ip} -p 5002 -t 4 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=1:0 --hide-histogram

${memtier_bin} -s ${remote_mem_ip} -p 5002 -t 4 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=0:1 --hide-histogram --out-file tcp_test.txt

cat tcp_test.txt | sed -E 's/\s+/,/g' | grep -vE '(=|--------)'
