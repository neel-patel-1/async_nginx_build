#!/bin/bash
confprefix=c6xx_dev
for i in device_*.conf; do
	devNum=$(echo "$i" | grep -Eo '[0-9]')
	filename="${confprefix}${devNum}.conf"
	mv $i $filename
done
sudo mv $confprefix* /etc
sudo service qat_service restart
