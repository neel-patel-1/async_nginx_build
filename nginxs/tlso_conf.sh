#!/bin/bash
>&2 echo "[info] offload AXDIMM emulation https server..."
sudo $DEFAULT_NGINX_BUILD/sbin/nginx -t
sudo sed -i '/pid/a ssl_engine qatengine;' $DEFAULT_NGINX_BUILD/conf/nginx.conf
sudo sed -i '/\s*sendfile\s*on;/d' $DEFAULT_NGINX_BUILD/conf/nginx.conf

#export OPENSSL_ENGINES=$OPENSSL_OFFLOAD_LIB/engines-1.1
#export LD_FLAGS="-L$OPENSSL_OFFLOAD"
#export LD_LIBRARY_PATH=$OPENSSL_OFFLOAD:/home/n869p538/crypto_mb/2020u3/lib:/home/n869p538/intel-ipsec-mb/lib
#echo "$OPENSSL_ENGINES:$LD_FLAGS:$LD_LIBRARY_PATH"
#sudo $DEFAULT_NGINX_BUILD/sbin/nginx
sudo env \
OPENSSL_ENGINES=$OPENSSL_OFFLOAD_LIB/engines-1.1 \
LD_FLAGS="-L$OPENSSL_OFFLOAD" \
LD_LIBRARY_PATH=$OPENSSL_OFFLOAD_LIB/engines-1.1:$OPENSSL_OFFLOAD_LIB:$CRYPTOMB_INSTALL_DIR/lib:$IPSEC_INSTALL_LIB:$LD_LIBRARY_PATH \
$DEFAULT_NGINX_BUILD/sbin/nginx
#$OPENSSL_OFFLOAD/apps/openssl version
#$OPENSSL_OFFLOAD/apps/openssl engine -t -c -v qatengine
#openssl engine -t -c -v qatengine
