#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export OPENSSL_ENGINES=$AXDIMM_ENGINES
export LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_ENGINES:$AXDIMM_DIR/lib

[ ! -f "${off_mem_bin}" ] && exit

cd ${offload_kvs_dir}
${off_mem_bin} -q -l notls:*:5001,*:5002 -Z -t 8 -o ssl_chain_cert=${offload_kvs_dir}/cert.pem,ssl_key=${offload_kvs_dir}/key.pem
