#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export LD_LIBRARY_PATH=$KTLS_OSSL:$LD_LIBRARY_PATH

[ ! -f "${ktls_mem_bin}" ] && echo "missing ktls memcached binary" && exit

${ktls_mem_bin} -l notls:*:5001,*:5002 -Z -t 8  -o ssl_kernel_tls,ssl_chain_cert=${kvs_dir}/cert.pem,ssl_key=${kvs_dir}/key.pem
