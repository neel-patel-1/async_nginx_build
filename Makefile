.PHONY: qtls axdimm all qtls_server axdimm_server ocperf default ktls configure

all: configure qtls axdimm ktls default spec ocperf 

configure: 
	./scripts/configure.sh

qtls:
	./scripts/qtls/build_qtls.sh

axdimm:
	./scripts/axdimm/bo.sh

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

