#!/bin/bash

echo "Establishing QAT group permissions"

USERNAME=n869p538
export ROOT_DIR=/home/n869p538/patched_async_mode_nginx
source $ROOT_DIR/scripts/async_libsrcs.source
export ICP_ROOT=$QTLS_DIR/QAT
sudo groupadd qat
sudo usermod -G qat $USERNAME

sudo chgrp qat /dev/qat_*
sudo chmod 660 /dev/qat_*
sudo chgrp qat /dev/usdm_drv
sudo chmod 660 /dev/usdm_drv
sudo chgrp qat /dev/uio*
sudo chmod 660 /dev/uio*
sudo chgrp qat /dev/hugepages
sudo chmod 770 /dev/hugepages
sudo chgrp qat /usr/local/lib/libqat_s.so
sudo chgrp qat /usr/local/lib/libusdm_drv_s.so
