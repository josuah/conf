CONF = bgpd.conf bgpd/ibgp.conf
include mk/conf.inc

mk/bgp: ${CONF}
mk/bgp/sync:
mk/bgp/clean:
