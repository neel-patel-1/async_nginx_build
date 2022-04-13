#!/bin/bash

echo "Building QAT Driver"

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx

source ${ROOT_DIR}/scripts/async_libsrcs.source
[ ! -d "${QTLS_DIR}/QAT" ] && mkdir $QTLS_DIR/QAT
cd $QTLS_DIR/QAT
#download tar if we don't have
[ ! -f "QAT.L.4.15.0-00011.tar.gz" ] && wget --no-check-certificate https://downloadmirror.intel.com/649693/QAT.L.4.15.0-00011.tar.gz
if [ !-f "${QTLS_DIR}/QAT/quickassist/qat/drivers/crypto/qat/qat_c62x/qat_c62x.ko" ]; then
	tar zxof QAT.L.4.15.0-00011.tar.gz
	./configure
	sudo make clean -j 35 
	sudo make all -j 35 >& make.txt
	sudo make install -j 35 >& makeinstall.txt
fi
