#!/bin/bash
>&2 echo "[info] qtls server ..."
sudo ${QTLS_NGINX_BIN}/nginx -t #test qtls config

sudo env \
OPENSSL_ENGINES=$OPENSSL_LIBS/engines-1.1 \
LD_LIBRARY_PATH=$OPENSSL_LIB \
${QTLS_NGINX_BIN}/nginx #start qtls config
