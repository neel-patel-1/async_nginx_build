#!/bin/bash
#install deps
apt install linux-tools-$(uname -r)

nmi=$(cat /proc/sys/kernel/nmi_watchdog)
para=$(cat /proc/sys/kernel/perf_event_paranoid)
[[ ! "$nmi" = "0" ]] && bash -c "echo 0 > /proc/sys/kernel/nmi_watchdog"
[[ ! "$para" = "0" ]] && bash -c "echo 0 > /proc/sys/kernel/perf_event_paranoid"
