#!/bin/bash

echo "starting qatzip build"

export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

#build code 
if [ ! -d "$QZ_ROOT" ]; then
	cd $QTLS_DIR
	git clone --depth 1 --branch v1.0.6 https://github.com/intel/QATzip.git
fi

cd $QZ_ROOT

sudo ./setenv.sh
sudo bash -c "echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages"
sudo rmmod usdm_drv
sudo insmod $ICP_ROOT/scripts/usdm_drv.ko max_huge_pages=1024 max_huge_pages_per_process=16

cd $QZ_ROOT
sudo ./setenv.sh
./configure --with-ICP_ROOT=$ICP_ROOT
make clean -j 35
sudo make all install -j 35

#assume drivers installed
sudo service qat_service restart
