#!/bin/bash
dut=192.168.1.1

export WRK_ROOT=/home/n869p538/wrk_offloadenginesupport
source $WRK_ROOT/vars/env.src
source $WRK_ROOT/vars/environment.src

#${default_wrk} -t10 -c1024  -d2   http://${dut}/rand_file_4K.txt
#-H'accept-encoding:gzip, deflate'

sudo env \
OPENSSL_ENGINES=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/axdimm/openssl/lib/engines-1.1 \
LD_LIBRARY_PATH=/home/n869p538/wrk_offloadenginesupport/async_nginx_build/axdimm/openssl/lib/engines-1.1:/home/n869p538/wrk_offloadenginesupport/async_nginx_build/axdimm/openssl/lib:/home/n869p538/wrk_offloadenginesupport/async_nginx_build/axdimm/lib \
${default_wrk} -t20 -c1024  -d5  https://192.168.1.1:443/file_256K.txt
#${engine_wrk} -e qatengine -t20 -c1024  -d5   https://192.168.1.1:443/file_256K.txt
#${default_wrk} -t20 -c1024  -d5  https://192.168.1.1:443/file_256K.txt

#LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_DIR/lib \
