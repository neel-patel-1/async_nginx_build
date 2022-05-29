.PHONY: qtls axdimm all qtls_server axdimm_server ocperf default

all: qtls axdimm default spec ocperf

qtls:
	./scripts/configure.sh && ./scripts/qtls/build_qtls.sh

axdimm:
	./scripts/configure.sh && ./scripts/axdimm/bo.sh

default:
	./scripts/configure.sh && ./scripts/default/build_default.sh

spec:
	./scripts/configure.sh && ./scripts/ktls/ktls_build.sh

spec:
	./scripts/configure.sh && ./scripts/spec/build_spec.sh

ocperf:
	./scripts/configure.sh && ./scripts/ocperf/build_ocperf.sh

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

