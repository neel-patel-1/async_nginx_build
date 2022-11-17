#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

SEP=( "0" "11" "12" "13" "14" "15" "16" "17" "18" "19" )
SHARED=( "21" "22" "23" "24" "25" "26" "27" "28" "29" "40" )

CORES=SEP
if [ "${1}" = "shared" ]; then
	CORES=${SHARED[*]}
else
	CORES=${SEP[*]}
fi

args=( "$@" )

dir=$( echo ${args[@]:1} | sed 's/ /_/g' )
echo $dir
[ ! -d "${ROOT_DIR}/$dir" ] && mkdir ${ROOT_DIR}/$dir
[ ! -z "$(ls -A ${ROOT_DIR}/$dir)" ] && echo "files present in output dir -- save before running" && exit
cd ${ROOT_DIR}/$dir

PIDS=( $(pgrep mcf_r) )

#1 - process to monitor memory bandwidth of
spec_cpu_mon(){
	while [ "1" ]; do
		time=$(printf '%(%H:%M:%S)T')
		cpu_util=$( top -b -n 2 -d 0.1 -p ${1} 2>/dev/null | tail -1 | awk '{print $6}'  )
		echo "${time} ${cpu_util}" | grep -v '%CPU' >> mcf_r_${1}.cpu
		sleep 0.2
	done

}

#1 - process to monitor memory bandwidth of
spec_mon(){
	OF=mcf_r_${1}.mem
	rm -f mcf_r_${1}.mem
	sudo pqos -i 1 -I -p "mbl:${1};llc:${1}" -o mcf_r_${1}.mem
}

sudo pqos -R 
sudo pqos -e "llc:1=0x003F;" #6 ways
for i in ${CORES[@]};
do
	taskset -c ${i} ${ROOT_DIR}/cpu_2017/bin/runcpu --iterations=1 --copies=1 -o csv 505.mcf_r >/dev/null &
done

while [ "${#PIDS[@]}" -lt ${#CORES[@]} ]; do
	PIDS=( $(pgrep specperl ) )
done

echo "got pids: ${PIDS[*]}"
	
for p in "${PIDS[@]}"; do
	spec_mon $p &
	MONS+=( "$!" )
	spec_cpu_mon $p &
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
		sleep 0.4
	done
done

# kill monitors
for i in "${MONS[@]}"; do
	echo "kill monitor : ${i}"
	sudo kill -KILL ${i}
done

exit
