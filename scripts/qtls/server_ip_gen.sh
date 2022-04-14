#!/bin/bash

#100GBit/s / 10 Gbit per IP ~ 10 IPs
num_ips=10

for i in `seq 2 $(( $num_ips + 2 ))`; do
	sudo ifconfig ${NETDEV}:$i 192.168.${i}.2/24
done
