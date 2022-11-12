#!/bin/bash

clis=( "1" "50" "50" "50" "50" "50" "100" "125" )
tds=( "1" "1" "2" "4" "8" "16" "16" "16" )
s_size=$1
vsize=$2
for i in "${!clis[@]}" ;do

	NUM=${clis[i]}
	TDS=${tds[i]}
	DF=$(( NUM * TDS ))Cli_${s_size}Server_${vsize}Requests.data
	if [ ! -f "${DF}" ]; then
		#DF=$(( NUM * TDS))Cli_${s_size}Server_${vsize}Requests.data
		#MD_F=$(( NUM * TDS))Cli_${s_size}_${vsize}Requests_loads.perf
		#FS=$(( NUM * TDS))Cli_${s_size}_${vsize}Requests_DRAM_Rate.perf

		[ -z "$NUM" ] && echo "no num" && exit
		MEM_PID=$( ps aux | grep 'memcached' | grep -v grep | grep -v vim | grep -v rdtset | grep -v bash | grep -v objdump | awk '{ print $2 }' )
		echo "using $MEM_PID"

		if [ ! -f "$DF" ]; then
			ssh castor "/home/n869p538/wrk_offloadenginesupport/async_nginx_build/scripts/kvs/tls_memory_antagonist_fetch.sh $s_size $vsize ${tds[i]} ${clis[i]}" &
			sleep 1.5
			perf mem record -C 1-10 --pid $MEM_PID sleep 60
			mv perf.data $DF
			ssh castor "ps aux | grep memtier | awk '{print \$2}' | xargs sudo kill -s 2"
		fi

		#[ ! -f "$MD_F" ] && perf mem report -v -i $DF --stdio > $MD_F
		#DRAM_RATE=$( grep assoc_find $MD_F | grep RAM | wc -l )
		#MEM_RATE=$( grep assoc_find $MD_F | wc -l )
		#echo "${DRAM_RATE} / ${MEM_RATE}" | bc | tee $DF

	fi
done

