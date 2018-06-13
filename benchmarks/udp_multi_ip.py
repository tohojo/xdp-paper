# Modified from trex, to also vary UDP dport when running multiple streams
from trex_stl_lib.api import *
import random

# Quick and dirty martian avoidance: Just don't generate these octets
ALLOWED_OCTETS = list(range(1,254))
ALLOWED_OCTETS.remove(10)
ALLOWED_OCTETS.remove(100)
ALLOWED_OCTETS.remove(127)
ALLOWED_OCTETS.remove(169)
ALLOWED_OCTETS.remove(172)
ALLOWED_OCTETS.remove(192)
ALLOWED_OCTETS.remove(224)
ALLOWED_OCTETS.remove(240)

# Tunable example
#
#trex>profile -f stl/udp_for_benchmarks.py
#
#Profile Information:
#
#
#General Information:
#Filename:         stl/udp_for_benchmarks.py
#Stream count:          1
#
#Specific Information:
#Type:             Python Module
#Tunables:         ['stream_count = 1', 'direction = 0', 'packet_len = 64']
#
#trex>start -f stl/udp_for_benchmarks.py -t  packet_len=128 --port 0
#

class STLS1(object):
    '''
    Generalization of udp_1pkt_simple, can specify number of streams and packet length
    '''
    def create_stream (self, packet_len, stream_count, port_count):
        packets = []
        if port_count < 1:
            port_count = 1

        if stream_count < port_count:
            stream_count = port_count

        for i in range(stream_count):
            port = 12 + (i % port_count)
            dst = "%d.%d.%d.%d" % [random.choice(ALLOWED_OCTETS) for i in range(4)]
            base_pkt = Ether()/IP(src="16.0.0.1",dst=dst)/UDP(dport=port,sport=1025)
            base_pkt_len = len(base_pkt)
            base_pkt /= 'x' * max(0, packet_len - base_pkt_len)
            packets.append(STLStream(
                packet = STLPktBuilder(pkt = base_pkt),
                mode = STLTXCont()
                ))
        return packets

    def get_streams (self, direction = 0, packet_len = 64, stream_count = 1, port_count = 1, **kwargs):
        # create 1 stream
        return self.create_stream(packet_len - 4, stream_count, port_count)


# dynamic load - used for trex console or simulator
def register():
    return STLS1()
