.PHONY: qtls axdimm all qtls_server axdimm_server ocperf default

all: qtls axdimm default spec ocperf

qtls:
	./configure && ./scripts/qtls/build_qtls.sh

axdimm:
	./configure && ./scripts/axdimm/bo.sh

default:
	./configure && ./scripts/default/build_default.sh

spec:
	./configure && ./scripts/spec/build_spec.sh

ocperf:
	./configure && ./scripts/ocperf/build_ocperf.sh

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
