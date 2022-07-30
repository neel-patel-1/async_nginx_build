#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

[ -z "$qat_thresh" ] && qat_thresh=50
[ -z "$mellanox_thresh" ] && mellanox_thresh=50
[ -z "$qat_name" ] && qat_name="pch_lewisburg-virtual-0"
[ -z "$mel_dev" ] && mel_devs=( "/dev/mst/mt41686_pciconf0" "/dev/mst/mt41686_pciconf0.1" )

wall "install temp mon"
if [ ! -d "/dev/mst" ]; then 
	wall "installing mellanox driver"
	mst start
fi

while true; do
	for i in "${mel_devs[@]}"; do
		mtemp=$(mget_temp -d $i)
		if [ "$mtemp" -gt "$mellanox_thresh" ]; then
			wall "mellanox temp too high"
			shutdown now
		fi
	done


	for i in /dev/mst/*; do
		mtemp=$(mget_temp -d $i)
		if [ "$mtemp" -gt "$mellanox_thresh" ]; then
			wall "mellanox temp too high"
			shutdown now
		fi
	done
	

	qat_temp=$( sensors | sed -n "/$qat_name/{N;N;p}" | tail -n 1 | grep -Eo '[+|-][0-9]*' | grep -Eo '[0-9]*' )

	if [ ! -z "$qat_temp" ] && [ "$qat_temp" -gt "$qat_thresh" ]  ; then
			wall "qat temp too high"
			shutdown now
	fi
	sleep 2

done
