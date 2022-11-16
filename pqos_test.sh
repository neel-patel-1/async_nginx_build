#!/bin/bash
CORES=( "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" )
#CORES=( "1" "2"  )
PIDS=( $(pgrep mcf_r) )

spec_mon(){
	#while kill -0 ${1} 2>/dev/null; do
	OF=mcf_r_${1}.mem
	rm -f mcf_r_${1}.mem
	sudo pqos -i 1 -I -p "mbl:${1};llc:${1}" -o mcf_r_${1}.mem
}

sudo pqos -R 
#sudo pqos -e "llc:1=0x0007;"
for i in ${CORES[@]};
do
	taskset -c ${i} ./cpu_2017/bin/runcpu --dry-run --iterations=1 --copies=1 -o csv 505.mcf_r >/dev/null &
done

while [ "${#PIDS[@]}" -lt ${#CORES[@]} ]; do
	PIDS=( $(pgrep specperl ) )
done

echo "got pids: ${PIDS[*]}"
	
for p in "${PIDS[@]}"; do
	spec_mon $p &
	MONS+=( "$!" )
done

# watch for runcpu completion
comp=0
while [ "${comp}" = 0 ];do
	comp=1
	for p in "${PIDS[@]}"; do
		echo "checking: $p complete?"
		kill -0 $p 2>/dev/null
		comp=$?;
		sleep 1
	done
done

# kill monitors
for i in "${MONS[@]}"; do
	echo "kill monitor : ${i}"
	sudo kill -KILL ${i}
done

exit
