#!/bin/bash

module=rw_test
if [ ! -z "$(sudo lsmod | grep $module)" ]; then
	sudo dmesg -C
	sudo dmesg -D
	make
	sudo dmesg -E
	sudo ./user_cpy
	sudo dmesg | tee cpy.out
fi
