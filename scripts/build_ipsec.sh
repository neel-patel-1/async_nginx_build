#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

if [ ! -d "$QTLS_DIR/intel-ipsec-mb" ]; then
	cd $QTLS_DIR
	git clone --depth 1 --branch v0.55 https://github.com/intel/intel-ipsec-mb.git
fi

cd $QTLS_DIR/intel-ipsec-mb
make -j SAFE_DATA=y SAFE_PARAM=y SAFE_LOOKUP=y
sudo make install NOLDCONFIG=y PREFIX=$QTLS_DIR/ipsec-mb/0.55
