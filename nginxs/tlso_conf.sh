#!/bin/bash
>&2 echo "[info] offload AXDIMM emulation https server..."
sudo $DEFAULT_NGINX_BUILD/sbin/nginx -t
sudo sed -i '/pid/a ssl_engine qatengine;' $DEFAULT_NGINX_BUILD/conf/nginx.conf
sudo sed -i '/\s*sendfile\s*on;/d' $DEFAULT_NGINX_BUILD/conf/nginx.conf

sudo env \
OPENSSL_ENGINES=$OPENSSL_OFFLOAD_LIB/engines-1.1 \
LD_FLAGS="-L$OPENSSL_OFFLOAD" \
LD_LIBRARY_PATH=$OPENSSL_OFFLOAD:/home/n869p538/crypto_mb/2020u3/lib:/home/n869p538/intel-ipsec-mb/lib \
$DEFAULT_NGINX_BUILD/sbin/nginx
