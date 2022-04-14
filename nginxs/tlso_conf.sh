#!/bin/bash
>&2 echo "[info] AXDIMM server..."
sudo $AXDIMM_NGINX/sbin/nginx -t

#no sendfile
sudo sed -i -E "s/(worker_processes) (.*)(;)/\1 $cores\3/g" ${AXDIMM_NGINX}/conf/nginx.conf
sudo sed -i -E "s/(worker_cpu_affinity) (.*)(;)/\1 $newMaskp1$newMaskp2\3/g" ${AXDIMM_NGINX}/conf/nginx.conf

sudo env \
OPENSSL_ENGINES=$AXDIMM_ENGINES/lib/engines-1.1 \
LD_LIBRARY_PATH=$AXDIMM_OSSL_LIBS:$AXDIMM_DIR/crypto_mb/2020u3/lib:$AXDIMM_DIR/ipsec-mb/0.55/lib \
${AXDIMM_NGINX}/sbin/nginx
