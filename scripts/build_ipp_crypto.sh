#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$QTLS_DIR/ipp-crypto" ]; then
	cd $QTLS_DIR
	git clone  https://github.com/intel/ipp-crypto.git
fi

cd $QTLS_DIR/ipp-crypto
git checkout ipp-crypto_2021_5
cd sources/ippcp/crypto_mb
CRYPTO_DIR=$(cmake . -Bbuild -DCMAKE_INSTALL_PREFIX=$QTLS_DIR/crypto_mb/2020u3 | grep 'Build files' | awk '{print $8}')
cd $CRYPTO_DIR
[[ "$(grep -E 'export CRYPTO_DIR=.*' scripts/async_libsrcs.source)" == "" ]] && echo "export CRYPTO_DIR=$CRYPTO_DIR" >> $ROOT_DIR/scripts/async_libsrcs.source
make -j 35
sudo make install -j 35
