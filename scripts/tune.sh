#!/bin/bash
ufw disable                                                                     #disable Debian firewall
iptables -F                                                                     #flush the iptables rules
#TCP Memory
echo 16777216                > /proc/sys/net/core/rmem_max
echo 16777216                > /proc/sys/net/core/wmem_max
echo 16777216                > /proc/sys/net/core/rmem_default
echo 16777216                > /proc/sys/net/core/wmem_default
echo 16777216 16777216 16777216  > /proc/sys/net/ipv4/tcp_rmem
echo 538750 538750 538750  > /proc/sys/net/ipv4/tcp_wmem
echo 16777216            > /proc/sys/net/core/optmem_max
echo 16777216 16777216  16777216 > /proc/sys/net/ipv4/tcp_mem
echo 65536       > /proc/sys/vm/min_free_kbytes                                  #ensure there will always be free
#TCP Behavior
echo 0                     > /proc/sys/net/ipv4/tcp_timestamps
echo 0                     > /proc/sys/net/ipv4/tcp_sack
echo 0                     > /proc/sys/net/ipv4/tcp_fack
echo 0                     > /proc/sys/net/ipv4/tcp_dsack
echo 0                     > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
echo 1                     > /proc/sys/net/ipv4/tcp_rfc1337
echo 600        > /proc/sys/net/core/netdev_budget
echo 128                   > /proc/sys/net/core/dev_weight
echo 1                     > /proc/sys/net/ipv4/tcp_syncookies
echo 0                     > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo 1                     > /proc/sys/net/ipv4/tcp_no_metrics_save
echo 1                     > /proc/sys/net/ipv4/tcp_orphan_retries
echo 0                     > /proc/sys/net/ipv4/tcp_fin_timeout
echo 0                     > /proc/sys/net/ipv4/tcp_tw_reuse
echo 0                     > /proc/sys/net/ipv4/tcp_tw_recycle
echo 1                     > /proc/sys/net/ipv4/tcp_syncookies
echo 2                       > /proc/sys/net/ipv4/tcp_synack_retries
echo 2                     > /proc/sys/net/ipv4/tcp_syn_retries
echo cubic                   > /proc/sys/net/ipv4/tcp_congestion_control
echo 0                     > /proc/sys/net/ipv4/tcp_low_latency
echo 1                     > /proc/sys/net/ipv4/tcp_window_scaling
echo 1                     > /proc/sys/net/ipv4/tcp_adv_win_scale
#TCP Queueing
echo 0                > /proc/sys/net/ipv4/tcp_max_tw_buckets
echo 1025 65535            > /proc/sys/net/ipv4/ip_local_port_range
echo 131072                > /proc/sys/net/core/somaxconn
echo 262144            > /proc/sys/net/ipv4/tcp_max_orphans
echo 262144           > /proc/sys/net/core/netdev_max_backlog
echo 262144        > /proc/sys/net/ipv4/tcp_max_syn_backlog
echo 4000000             > /proc/sys/fs/nr_open

echo 4194304     > /proc/sys/net/ipv4/ipfrag_high_thresh
echo 3145728     > /proc/sys/net/ipv4/ipfrag_low_thresh
echo 30      > /proc/sys/net/ipv4/ipfrag_time
echo 0   > /proc/sys/net/ipv4/tcp_abort_on_overflow
echo 1       > /proc/sys/net/ipv4/tcp_autocorking
echo 31      > /proc/sys/net/ipv4/tcp_app_win
echo 1       > /proc/sys/net/ipv4/tcp_mtu_probing
set selinux=disabled
ulimit -n 1000000
