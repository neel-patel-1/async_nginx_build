#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

cd ${AXDIMM_DIR}/qat_cache_flush
PERL5LIB=$AXDIMM_DIR/openssl make -j 4
sudo PERL5LIB=$AXDIMM_DIR/openssl make install -j 4

