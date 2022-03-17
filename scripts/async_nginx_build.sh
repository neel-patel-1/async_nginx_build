#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source $ROOT_DIR/scripts/async_libsrcs.source
cd $BUILD_DIR/asynch_mode_nginx

htmlcontents=$BUILD_DIR/asynch_mode_nginx

./configure \
--prefix=$NGINX_INSTALL_DIR \
--without-http_rewrite_module \
--with-http_ssl_module \
--add-dynamic-module=modules/nginx_qat_module/ \
--with-cc-opt="-DNGX_SECURE_MEM -I$OPENSSL_LIB/include -I$ICP_ROOT/quickassist/include -I$ICP_ROOT/quickassist/include/dc -Wno-error=deprecated-declarations -Wimplicit-fallthrough=0" \
--with-ld-opt="-Wl,-rpath=$OPENSSL_LIB/lib -L$OPENSSL_LIB/lib"

make -j 35
sudo make install -j 35

cd $NGINX_INSTALL_DIR
sudo cp -r $ROOT_DIR/async_files/* ./html
sudo cp -r $ROOT_DIR/async_certs/* ./conf
