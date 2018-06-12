#!/bin/bash
#
#
DOC='For DPDK, enable huge pages'

if [ "$EUID" -ne 0 ]; then
    echo "Need root priviliges"
    exit 1
fi
echo $DOC

echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

if [ ! -d /mnt/huge ]; then
    mkdir /mnt/huge
fi

mount -t hugetlbfs nodev /mnt/huge

df /mnt/huge/
