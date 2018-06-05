Notes for DPDK setup
====================

DPDK is needed for both comparison testing against XDP and for having
a faster packet generator.

Tariq reports that using DPDK based T-rex, he can send with 125Mpps
(multi-TXq + CPU cores).


Fedora packages
===============

Fedora comes with DPDK packaged::

 dnf install dpdk dpdk-tools
 dnf install dpdk-devel dpdk-doc
 dnf install python-pyelftools

First run had issues with dependencies::

 $ sudo dpdk-pmdinfo
 Traceback (most recent call last):
  File "/bin/dpdk-pmdinfo", line 14, in <module>
    from elftools.common.exceptions import ELFError
 ImportError: No module named elftools.common.exceptions

Missing deps on python-pyelftools ::

 sudo dnf install python-pyelftools


Setup DPDK based trex
=====================

It's possible to download binary version of trex, and install that
from a tar.gz file, see instructions here:

 https://trex-tgn.cisco.com/trex/doc/trex_manual.html#_download_and_installation

Generate config::

 sudo ./dpdk_setup_ports.py -c 09:00.0 09:00.1 -o trex_cfg02.yaml
 sudo ./dpdk_setup_ports.py -i


Mellanox requires out-of-tree drivers
=====================================

http://www.mellanox.com/page/products_dyn?product_family=26&mtag=linux_sw_drivers

Download for Fedora 27:
 http://www.mellanox.com/page/mlnx_ofed_eula?mtag=linux_sw_drivers&mrequest=downloads&mtype=ofed&mver=MLNX_OFED-4.3-1.0.1.0&mname=MLNX_OFED_LINUX-4.3-1.0.1.0-fc27-x86_64.tgz


What does Red Hat perf team use
===============================

From: Andrew Theurer <atheurer@redhat.com> ::

 We are using TRex, with our own scripts for the binary-search.  All of our
 scripts are here: https://github.com/atheurer/trafficgen

 First, install trex: install-trex.sh
 Next, configure/launch trex: launch-trex.sh
 Finally, run a test: binary-search.py

 We recommend using Intel XL710 or XVV710 adapters to drive traffic.  Intel
 Niantic will work, but it does not filter incoming packets reliably, so we
 can't get per-stream stats.

setup issues
------------

Manually created file for trex and could start it with:

 sudo ./launch-trex.sh --yaml-file=/etc/trex_cfg02-ixgbe.yaml

