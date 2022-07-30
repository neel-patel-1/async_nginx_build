#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export OPENSSL_ENGINES=$AXDIMM_ENGINES
export LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_ENGINES

[ ! -f "${mem_bin}" ] && exit

${mem_bin} -t 8 -Z -U 5002 -o ssl_chain_cert=${kvs_dir}/cert.pem,ssl_key=${kvs_dir}/key.pem
