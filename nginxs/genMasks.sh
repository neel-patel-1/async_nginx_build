
#set root directory
export ROOT_DIR=/home/n869p538/async_nginx_build

#get global variables
source ${ROOT_DIR}/scripts/async_libsrcs.source


[ -z "$cores" ] && cores=$1

[ "$logical" != "y" ] && echo "coremask configured for pinning logical siblings" && exit

#check that num_phys logical nginxs is leq num_phys phys - 1
[ ! "$cores" -lt "$num_phys" ] && echo "too many nginx workers" && exit

masks=()
# cores 1-19 allowed,  core 0 not allowed

ctr=1
for i in `seq 1 $cores`; do #make a mask for each core
	mask="" #fresh
	for j in `seq 1 $((${num_phys}))`; do
		mask+=0 #not allowed last 20 log
	done
	#echo "$(echo "$mask" | wc -c)"
	mask2=""
	mask2+=0 #core zero not allowed
	for j in `seq 1 $(($num_phys - 1))`; do
		if [ "$j" = "$ctr" ]; then #this core is allowed for this nginx worker
			mask2+=1
		else 
			mask2+=0 
		fi
	done
	#echo $(echo "$mask2" | wc -c)
	mask2=$(echo "$mask2" | rev)
	ctr=$(($ctr + 1))
	masks+=("$mask$mask2")
	#echo $(echo "$mask$mask2" | wc -c)
done

mskStmt="worker_cpu_affinity ${masks[*]} ;"

echo 
