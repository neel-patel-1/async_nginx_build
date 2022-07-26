OFF_SSL=/home/n869p538/async_nginx_build/axdimm/openssl

.PHONY: qtls axdimm all qtls_server axdimm_server ocperf default ktls configure axdimm_test axdimm_test_server

all: configure qtls axdimm ktls default spec ocperf axdimm_test

configure: 
	./scripts/configure.sh

qtls:
	./scripts/qtls/build_qtls.sh

axdimm:
	./scripts/axdimm/bo.sh

axdimm_test:
	./scripts/axdimm_test/build_test.sh

default:
	./scripts/default/build_default.sh

ktls:
	./scripts/ktls/ktls_build.sh

spec:
	./scripts/spec/build_spec.sh

ocperf:
	./scripts/ocperf/build_ocperf.sh

qtls_server:
	./nginx.sh qtls

axdimm_server:
	./nginx.sh axdimm

sendfile_server:
	./nginx.sh httpsendfile

http_server:
	./nginx.sh http

https_server:
	./nginx.sh https

ktls_server:
	./nginx.sh ktls

tls_iperf: ./iperf_test/iperf_w_offload/bin/iperf
	-[ ! -d "iperf_test" ] && mkdir iperf_test
	cd iperf_test && \
	git clone https://github.com/neelpatelbiz/iperf_w_offload.git && \
	cd iperf_w_offload && \
	env CFLAGS="-O2 -I${OFF_SSL}/include" LIBS="-l:libssl.so.1.1 -l:libcrypto.so.1.1" \
	LD_FLAGS="-L${OFF_SSL}" ./configure --prefix=$$(pwd) && \
	make -j 4 && \
	make install -j 4

iperf_server: tls_iperf
	./scripts/iperf/iperf_offload.sh

clean:
	cd iperf_test/iperf_w_offload && \
	make clean && \
	make distclean
