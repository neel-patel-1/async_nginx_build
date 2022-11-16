#!/bin/bash
#CORES=( "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" )
CORES=( "1" "2"  )
PIDS=( $(pgrep mcf_r) )

spec_mon(){
	#while kill -0 ${1} 2>/dev/null; do
	OF=mcf_r_${1}.mem
	rm -f mcf_r_${1}.mem
	while [ "1" ]; do
		sudo pqos -t 1 -i 1 -I -p "mbl:${1};llc:${1}" >> mcf_r_${1}.mem
		sleep 1
	done
}

sudo pqos -R 
#sudo pqos -e "llc:1=0x0007;"
for i in ${CORES[@]};
do
	taskset -c ${i} ./cpu_2017/bin/runcpu --dry-run --iterations=1 --copies=1 -o csv 505.mcf_r >/dev/null &
done

while [ "${#PIDS[@]}" -lt ${#CORES[@]} ]; do
	PIDS=( $(pgrep runcpu ) )
done

echo "got pids: ${PIDS[*]}"
	
for p in "${PIDS[@]}"; do
	spec_mon $p &
done


comp=0
while [ "${comp}" = 0 ];do
	comp=1
	for p in "${PIDS[@]}"; do
		echo "checking: $p complete?"
		if [ $(kill -0 $p 2>/dev/null) ]; then
			comp=0;
		fi
		sleep 1
	done
done

pgrep pqos
ps aux | grep pqos
sudo kill -s 2 $( pgrep pqos )
exit
