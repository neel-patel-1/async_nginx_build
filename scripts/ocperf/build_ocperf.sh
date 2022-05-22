#!/bin/bash
export ROOT_DIR=/home/n869p538/async_nginx_build
source $ROOT_DIR/scripts/async_libsrcs.source

#check NMI watchdog ++ enable memory accesses
nmi=$(sudo cat /proc/sys/kernel/nmi_watchdog)
para=$(sudo cat /proc/sys/kernel/perf_event_paranoid)
[[ ! "$nmi" = "0" ]] && sudo bash -c "echo 0 > /proc/sys/kernel/nmi_watchdog"
[[ ! "$para" = "0" ]] && sudo bash -c "echo 0 > /proc/sys/kernel/perf_event_paranoid"

cd $ROOT_DIR
if [ ! -f ${OCPERF} ]; then
	git clone https://github.com/andikleen/pmu-tools.git
fi

${OCPERF} stat -e 'llc_misses.mem_read' sleep 1
