#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

export OPENSSL_ENGINES=$AXDIMM_ENGINES
export LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_ENGINES

[ ! -f "${mem_bin}" ] && exit
NCORES=10
MEMSIZE=$(( 1 * 1024 * 1024 ))

sudo rdtset -r 1-$NCORES -t "l3=0x80;cpu=1-$NCORES" -c 1-$NCORES\
	${mem_bin} -l notls:*:5001,*:5002 -Z -t 20  -o ssl_chain_cert=${kvs_dir}/cert.pem,ssl_key=${kvs_dir}/key.pem \
	-m $MEMSIZE
