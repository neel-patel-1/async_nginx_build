#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ ! -d "$iperf_dir" ] && mkdir $iperf_dir
cd $iperf_dir
[ ! -d "iperf_w_offload" ] && git clone git@gitlab.ittc.ku.edu:n869p538/iperf_w_offload.git
if [ ! -f "iperf_w_offload/src/iperf" ]; then
	cd iperf_w_offload
	env CFLAGS="-O2 -I${AXDIMM_OSSL_LIBS}/../include" LIBS="-l:libssl.so.1.1 -l:libcrypto.so.1.1" LD_FLAGS="-L${AXDIMM_OSSL_LIBS}" ./configure --prefix=$(pwd)
	make -j
fi

