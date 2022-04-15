#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

cd $QTLS_DIR
git clone https://github.com/intel/asynch_mode_nginx.git
cd $QTLS_DIR/asynch_mode_nginx

./configure \
--prefix=$QTLS_NGINX \
--without-http_rewrite_module \
--with-http_ssl_module \
--add-dynamic-module=modules/nginx_qat_module/ \
--with-cc-opt="-DNGX_SECURE_MEM -I$OPENSSL_LIB/include -I$ICP_ROOT/quickassist/include -I$ICP_ROOT/quickassist/include/dc -Wno-error=deprecated-declarations -Wimplicit-fallthrough=0" \
--with-ld-opt="-Wl,-rpath=$OPENSSL_LIB/lib -L$OPENSSL_LIB/lib"

make -j 35
sudo make install -j 35

cd $QTLS_NGINX
sudo cp -r $ROOT_DIR/async_files/* ./html
sudo cp -r $ROOT_DIR/async_certs/* ./conf
sudo cp -r $ROOT_DIR/async_nginx_conf/* ./conf
