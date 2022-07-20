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

