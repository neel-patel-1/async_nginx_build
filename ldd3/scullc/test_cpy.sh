#!/bin/bash

module=scullc0

[ ! -z "$( lsmod | grep scullc )" ] && sudo ./scullc_unload
[ -z "$( lsmod | grep scullc )" ] && sudo ./scullc_load

make
make mmap
if [ ! -z "$(ls /dev | grep $module)" ]; then
	sudo dmesg -C
	sudo dmesg -D
	sudo dmesg -E
	sudo ./mmap &
	sudo dmesg | tee test_cpy.out
fi

