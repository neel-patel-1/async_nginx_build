#!/bin/bash
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$BUILD_DIR/intel-ipsec-mb" ]; then
	cd $BUILD_DIR
	git clone --depth 1 --branch v0.55 https://github.com/intel/intel-ipsec-mb.git
fi

cd $BUILD_DIR/intel-ipsec-mb
make -j SAFE_DATA=y SAFE_PARAM=y SAFE_LOOKUP=y
sudo make install NOLDCONFIG=y PREFIX=$BUILD_DIR/ipsec-mb/0.55
