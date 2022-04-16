#!/bin/bash
>&2 echo "[info] AXDIMM server..."
sudo env \
OPENSSL_ENGINES=$AXDIMM_ENGINES \
LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_DIR/intel-ipsec-mb/lib \
$AXDIMM_NGINX/sbin/nginx -t
#do we need to add crypto_mb to the path -- the engine is not linked against it

#no sendfile
sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${AXDIMM_NGINX}/conf/nginx.conf
sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/\1 $newMaskp1$newMaskp2\3/g" ${AXDIMM_NGINX}/conf/nginx.conf


#LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_DIR/intel-ipsec-mb/lib \
sudo env \
OPENSSL_ENGINES=$AXDIMM_ENGINES \
LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_DIR/intel-ipsec-mb/lib \
${AXDIMM_NGINX}/sbin/nginx

