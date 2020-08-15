#!/bin/bash

echo "This is id: $$ name: $0 running as $(whoami))"
echo "and I am dumping the memory from all the processes running under my name"

pids_list=$(ps -o pid -u $(whoami))

for pid in $pids_list; do
    echo "Dumping $pid ..."
    cat /proc/$pid/maps | grep "rw-p" | awk '{print $1}' | ( IFS="-"
    while read a b; do
        dd if=/proc/$pid/mem bs=$( getconf PAGESIZE ) iflag=skip_bytes,count_bytes skip=$(( 0x$a )) count=$(( 0x$b - 0x$a )) of="$1_mem_$a.bin"
    done
    )
    echo "Cleaning dump for pid:$pid"
    cat *_mem_*\.bin | strings >> dump.text
    rm *_mem_*\.bin
done
