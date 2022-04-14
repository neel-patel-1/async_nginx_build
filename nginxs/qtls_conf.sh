>&2 echo "qtls offload tls"
sudo ${QTLS_NGINX_BIN}/nginx -t #test qtls config

sudo env \
OPENSSL_ENGINES=$OPENSSL_LIBS/engines-1.1 \
LD_FLAGS="-L$OPENSSL_LIB" \
LD_LIBRARY_PATH=$OPENSSL_LIB:/home/n869p538/crypto_mb/2020u3/lib:/home/n869p538/intel-ipsec-mb/lib \
${QTLS_NGINX_BIN}/nginx #start qtls config
#$OPENSSL_LIB/bin/openssl engine -t -c -v qatengine # for debugging the engine

