#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

cd $ROOT_DIR/asynch_mode_nginx
source libsrcs.source
[ ! -d "$QAT_BUILD" ] && mkdir $QAT_BUILD

./autogen.sh
#env LDFLAGS="-L/home/n869p538/intel-ipsec-mb/lib -L/home/n869p538/crypto_mb/2020u3/lib" \
#CPPFLAGS="-I/home/n869p538/intel-ipsec-mb/lib/include -I/home/n869p538/crypto_mb/2020u3/include" \
./configure \
--prefix=$NGINX_INSTALL_DIR \
--with-http_ssl_module \
--add-dynamic-module=modules/nginx_qat_module/ \
--with-cc-opt="-DNGX_SECURE_MEM -I$OPENSSL_LIB/include -I$ICP_ROOT/quickassist/include -I$ICP_ROOT/quickassist/include/dc -Wno-error=deprecated-declarations" \
--with-ld-opt="-Wl,-rpath=$OPENSSL_LIB/lib -L$OPENSSL_LIB/lib "

make -j 35
sudo make install -j 35

#qz extensions
#--add-dynamic-module=modules/nginx_qatzip_module \
#--with-cc-opt="-DNGX_SECURE_MEM -I$OPENSSL_LIB/include -I$ICP_ROOT/quickassist/include -I$ICP_ROOT/quickassist/include/dc -I$QZ_ROOT/include -Wno-error=deprecated-declarations" \
#--with-ld-opt="-Wl,-rpath=$OPENSSL_LIB/lib -L$OPENSSL_LIB/lib -L$QZ_ROOT/src -lqatzip -lz"

PERL5LIB=$ROOT_DIR/openssl make -j35 -C .
#env PERL5LIB=$ROOT_DIR/openssl make -j35 -C .
#sudo env PERL5LIB=$ROOT_DIR/openssl make install -j
sudo PERL5LIB=$ROOT_DIR/openssl make install -j
