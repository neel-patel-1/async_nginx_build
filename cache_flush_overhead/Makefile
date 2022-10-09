.PHONY: cfo

#INCLUDES= -IQATzip/include -IQAT/quickassist/include/dc -IQAT/quickassist/include -Iisa-l/include -Ipapi/src
CXXFLAGS= -g -Wall $(INCLUDES) -DDO_DEBUG
LIBS =  -lpapi

cfo:
	gcc -o cfo main.c $(CXXFLAGS) $(LIBS)
papi:
	git submodule update --init --recursive
papi_lib:
	cd papi/src && ./configure && make -j && sudo make -j install
