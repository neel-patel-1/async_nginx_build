#!/bin/bash

[ -z "$qat_thresh" ] && qat_thresh=50
[ -z "$mellanox_thresh" ] && mellanox_thresh=50
[ -z "$qat_name" ] && qat_name="pch_lewisburg-virtual-0"
[ -z "$mel_dev" ] && mel_devs=( "/dev/mst/mt41682_pciconf0" "/dev/mst/mt41682_pciconf0.1" )

qat_temp=$( sensors | sed -n "/$qat_name/{N;N;p}" | tail -n 1 | grep -Eo '[+|-][0-9]*' | grep -Eo '[0-9]*' )

[ ! -d "/dev/mst" ] && sudo mst start

for i in "${mel_devs[@]}"; do
	mtemp=$(sudo mget_temp -d $i)
	echo "mellanox dev: $mtemp"
done

echo "qat temp: $qat_temp"

if [ "$qat_temp" -gt $qat_thresh ]; then
fi
