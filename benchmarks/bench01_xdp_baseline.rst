XDP benchmark baseline
======================

Record some baseline benchmarks for XDP.

And describe the hardware Toke and Jesper have.


What kind of benchmarks
=======================

XDP_DROP
--------

Parameters:
 * Different NICs
 * Touching reading data before drop vs not
 * Single RX-queue performance
 * Multi  RX-queue performance scaling

Q: Will a packet size test make sense?

Q: Should we compare against 'iptables -t raw -j DROP' ?


XDP_TX
------

TODO: Desc in paper how XDP_TX actually acheives bulking, by delaying
the tail/doorbell (until driver exit it's NAPI call).

XDP_PASS
--------

Idea: We could measure the overhead XDP introduce, by comparing
against iptables-raw drop?


XDP_REDIRECT
------------
The redirect needs a separate benchmark document.


Hardware: Jesper
================

DUT (Device Under Test):
 - CPU:

Jesper have more types of NICs.


Benchmarks: Jesper
==================

