#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export OPENSSL_ENGINES=$AXDIMM_ENGINES
export LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_DIR/lib

cd $offload_kvs_dir
[ ! -f "cert.pem" ] || [ ! -f "key.pem" ] && ${AXDIMM_OSSL_LIBS}/../apps/openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes 

${offload_memtier_bin} --tls --tls-skip-verify --tls_offload -s 192.168.1.2 -p 5002 -t 8 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=1:0 --hide-histogram

${offload_memtier_bin} --tls --tls-skip-verify --tls_offload -s 192.168.1.2 -p 5002 -t 8 -P memcache_text --key-pattern=S:S --key-minimum=1 --key-maximum=50 --ratio=0:1 --hide-histogram --out-file axdimm_test.txt

cat axdimm_test.txt | sed -E 's/\s+/,/g' | grep -vE '(=|--------)'
