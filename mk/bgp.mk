CONF = bgpd.conf
include mk/conf.inc

mk/bgp: ${CONF}
mk/bgp/sync:
mk/bgp/clean:
