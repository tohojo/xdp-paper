#!/bin/bash

VERB=add

if [[ "$1" == "-d" ]]; then
    VERB=del
    shift
fi

GATEWAY="$1"

if [ -z "$GATEWAY" ]; then
    echo "Usage: $0 [-d] <gateway> < iplist.txt" >&2
    exit 1
fi

while read line; do
    echo "route $VERB $line via $GATEWAY"
done | ip -b -
