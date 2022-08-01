#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source


${memtier_bin} --tls --tls-skip-verify -s 192.168.1.2 -p 5002 -t 8 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=1:0 --hide-histogram

${memtier_bin} --tls --tls-skip-verify -s 192.168.1.2 -p 5002 -t 8 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=1:1 --hide-histogram --out-file tls_test.txt

cat tls_test.txt | sed -E 's/\s+/,/g' | grep -vE '(=|--------)'
