#!/bin/bash
export ROOT_DIR=/home/n869p538/wrk_offloadenginesupport/async_nginx_build
source $ROOT_DIR/scripts/qat_devs.source
net_snapshot ()
{
        rx=0;tx=0
        for i in $ifaces;
        do
                cntr="bytes"
                snap=`ethtool -S $i 2>/dev/null`
                `echo "$snap" | grep -q ${cntr}_nic` && cntr="${cntr}_nic"
                if [ -n "$snap" ];
                then
                        let rx+="`echo \"$snap\" | grep "^ *rx_$cntr:" | cut -f2 -d:`"
                        let tx+="`echo \"$snap\" | grep "^ *tx_$cntr:" | cut -f2 -d:`"
                fi
        done
}

newtest=0
oldtest=0
newtest1=0
oldtest1=0
newtest2=0
oldtest2=0
old_interrupt=0
new_interrupt=0
old_perf=0
new_perf=0
old_err=0
new_err=0

net_snapshot
while true; do
        tstamp1=`date +%s.%N`
	if [ $NUM_QAT_DEVICES -eq 1 ];
	then
	newtest=`sudo cat /sys/kernel/debug/$QAT_COUNTER0/fw_counters |grep "s\[AE" |awk '{print $5}' | awk 'BEGIN {s=0} {s+=$1} END {print s}'`
	elif [ $NUM_QAT_DEVICES -eq 2 ];
	then
	newtest=`sudo cat /sys/kernel/debug/$QAT_COUNTER0/fw_counters |grep "s\[AE" |awk '{print $5}' | awk 'BEGIN {s=0} {s+=$1} END {print s}'`
	newtest1=`sudo cat /sys/kernel/debug/$QAT_COUNTER1/fw_counters |grep "s\[AE" |awk '{print $5}' | awk 'BEGIN {s=0} {s+=$1} END {print s}'`
	elif [ $NUM_QAT_DEVICES -eq 3 ];
	then
	newtest=`sudo cat /sys/kernel/debug/$QAT_COUNTER0/fw_counters |grep "s\[AE" |awk '{print $5}' | awk 'BEGIN {s=0} {s+=$1} END {print s}'`
	newtest1=`sudo cat /sys/kernel/debug/$QAT_COUNTER1/fw_counters |grep "s\[AE" |awk '{print $5}' | awk 'BEGIN {s=0} {s+=$1} END {print s}'`
	newtest2=`sudo cat /sys/kernel/debug/$QAT_COUNTER2/fw_counters |grep "s\[AE" |awk '{print $5}' | awk 'BEGIN {s=0} {s+=$1} END {print s}'`
	new_interrupt=`for j in $ifaces;do sudo cat /proc/interrupts  |grep "$j-" |awk '{for(i=3;i<NF;++i)s+=$i} END {printf "%f\n",s}'; done |awk '{t+=$1}END{printf "%f",t}'`
        waiting=`ss -a | grep TIME-WAIT | wc -l`
        connections=`ss -tp |grep nginx |wc -l`
        oldrx=$rx; oldtx=$tx;
	sleep .9
        tstamp2=`date +%s.%N`
        net_snapshot
        rx_avg=`echo "(8*($rx-$oldrx)/1000/1000/($tstamp2-$tstamp1))"|bc`
        tx_avg=`echo "(8*($tx-$oldtx)/1000/1000/($tstamp2-$tstamp1))"|bc`
	#calculate errors
	echo "[RX=$rx_avg |TX=$tx_avg |QAT0=$((($newtest-$oldtest))) |QAT1=$((($newtest1-$oldtest1))) |QAT2=$((($newtest2-$oldtest2))) |CONN=$connections |WAIT=$waiting |IRUPTS=`bc -l <<<  $new_interrupt-$old_interrupt |awk '{printf("%d",$1)}'` |ERRS=$(($new_err-$old_err))]"
        oldtest=$newtest
        oldtest1=$newtest1
        oldtest2=$newtest2
        old_interrupt=$new_interrupt
	old_err=$new_err
	fi
done
