.PHONY: qtls axdimm 

all: qtls axdimm

qtls:
	./configure && ./buildRelease

axdimm:
	./configure && ./build_offload.sh
	./nginx.sh tlso 10 
