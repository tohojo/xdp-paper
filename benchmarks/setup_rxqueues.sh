#!/bin/bash
DOC="Script to setup ethtool filter steering to RX-queues"

if [ -z "$1" ]; then
    echo $DOC
    echo "Usage: $0 DEVICE"
    exit 1
fi
IFACE=$1

START_PORT=12
NUM_RINGS=$(ethtool -n $IFACE| egrep '[0-9]+ RX rings available' | cut -f 1 -d ' ')

for ring in $(seq 0 $(($NUM_RINGS - 1))); do
    port=$((START_PORT + $ring))
    ethtool -N $IFACE flow-type udp4 dst-port $port action $ring
done
