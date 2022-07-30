#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source
[ ! -d "${ROOT_DIR}/spec_mnt" ] && mkdir ${ROOT_DIR}/spec_mnt
[ ! -d "${ROOT_DIR}/cpu_2017" ] && mkdir ${ROOT_DIR}/cpu_2017
if [ ! -f "${ROOT_DIR}/cpu2017-1_0_5.iso" ]; then
	echo "attempting to get spec from remote host"
	scp ${remotespec} ${ROOT_DIR}/cpu2017-1_0_5.iso
	[ ! -f "${ROOT_DIR}/cpu2017-1_0_5.iso" ] && echo "could not obtain spec" && exit
fi
sudo mount -t iso9660 -o ro,exec,loop ${ROOT_DIR}/cpu2017-1_0_5.iso ${ROOT_DIR}/spec_mnt
cd ${ROOT_DIR}/spec_mnt && ./install.sh -d ${SPEC_DIR}
cp ${ROOT_DIR}/spec_conf/testConfig.cfg ${SPEC_DIR}/config
cp ${ROOT_DIR}/spec_conf/default.cfg ${SPEC_DIR}/config
sudo rm -rf spec_mnt

