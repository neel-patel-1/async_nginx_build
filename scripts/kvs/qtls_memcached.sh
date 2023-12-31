#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export OPENSSL_ENGINES=$QTLS_ENGINES
export LD_LIBRARY_PATH=$QTLS_LIBS:$QTLS_ENGINES

[ ! -f "${qtls_mem_bin}" ] && exit

sudo taskset -c 1-16 ${qtls_mem_bin} --user=root -l notls:*:5001,*:5002 -Z -t 20 -o ssl_chain_cert=${kvs_dir}/cert.pem,ssl_key=${kvs_dir}/key.pem
