#!/usr/bin/env bash
set -euo pipefail
cd /home/liupengwei/redis-crc16-20261026
{
    date -Ins
    id
    uname -a
    cat /etc/os-release
    lscpu
    head -13 /proc/cpuinfo
    head -3 /proc/meminfo
    lsblk -d -o NAME,MODEL,SIZE,ROTA | grep -v '^loop'
    ethtool enp161s0f0np0 2>/dev/null
    for cpu in 320 322 324 326 328 330 332 334; do
        printf 'CPU %s siblings: ' "$cpu"
        cat "/sys/devices/system/cpu/cpu$cpu/topology/thread_siblings_list"
    done
    uptime
    cat /proc/sys/kernel/perf_event_paranoid
    sha256sum artifacts/*.patch artifacts/*source.tar.gz artifacts/*pristine.tar.gz
} > results/environment.txt
mpstat -P 320,321,322,323,324,325,326,327,328,329 1 3 > results/cpu-load-sample.txt
