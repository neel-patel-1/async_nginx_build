#!/bin/bash

echo "starting qatzip build"

export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source

#build code 
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
