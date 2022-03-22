#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$BUILD_DIR/ipp-crypto" ]; then
	cd $BUILD_DIR
	git clone --depth 1 --branch ippcp_2020u3 https://github.com/intel/ipp-crypto.git
fi

cd $BUILD_DIR/ipp-crypto
git checkout ippcp_2020u3
cd sources/ippcp/crypto_mb
CRYPTO_DIR=$(cmake . -Bbuild -DCMAKE_INSTALL_PREFIX=$BUILD_DIR/crypto_mb/2020u3 | grep 'Build files' | awk '{print $8}')
cd $CRYPTO_DIR
make -j 35
sudo make install -j 35
