#!/bin/bash
#
# Basic setup steps used for benchmarking of XDP_REDIRECT

function root_check_run_with_sudo() {
    # Trick so, program can be run as normal user, will just use "sudo"
    #  call as root_check_run_as_sudo "$@"
    if [ "$EUID" -ne 0 ]; then
        if [ -x $0 ]; then # Directly executable use sudo
            echo "Not root, running with sudo"
            sudo "$0" "$@"
            exit $?
        fi
        err 4 "cannot perform sudo run of $0"
    fi
}
root_check_run_with_sudo "$@"

# Disable Ethernet flow-control, this is network overload test
echo " --- Disable Ethernet flow-control ---"
ethtool -A ixgbe1 rx off tx off
ethtool -A ixgbe2 rx off tx off
ethtool -A mlx5p1 rx off tx off
ethtool -A mlx5p2 rx off tx off

# For optimal performance align NIC HW queue IRQs
# and make sure irqbalance don't reorder these
pkill irqbalance

echo " --- Align IRQs ---"
# I've named my NICs ixgbe1 + ixgbe2
for F in /proc/irq/*/ixgbe*-TxRx-*/../smp_affinity_list; do
   # Extract irqname e.g. "ixgbe2-TxRx-2"
   irqname=$(basename $(dirname $(dirname $F))) ;
   # Substring pattern removal
   hwq_nr=${irqname#*-*-}
   echo $hwq_nr > $F
   #grep . -H $F;
done
grep -H . /proc/irq/*/ixgbe*/../smp_affinity_list


echo " --- Align IRQs : mlx5 ---"
for F in /proc/irq/*/mlx5_comp*/../smp_affinity; do
	dir=$(dirname $F) ;
	cat $dir/affinity_hint > $F
done
grep -H . /proc/irq/*/mlx5_comp*/../smp_affinity_list

echo " --- Disable netfilter ---"
/home/jbrouer/netfilter_unload_modules.sh > /dev/null 2>&1

echo " --- Start netserver ---"
/usr/local/bin/netserver

