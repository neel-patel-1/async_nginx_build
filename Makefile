.PHONY: qtls axdimm all qtls_server axdimm_server

all: qtls axdimm

qtls:
	./configure && ./scripts/qtls/build_qtls.sh

axdimm:
	./configure && ./scripts/axdimm/build_offload.sh

qtls_server:
	./nginx.sh qtls

axdimm_server:
	./nginx.sh axdimm

sendfile_server:
	./nginx.sh sendfile

http_server:
	./nginx.sh http

https_server:
	./nginx.sh https
