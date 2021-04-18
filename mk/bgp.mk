CONF = bgpd/group-ibgp.conf bgpd.conf bgpd/roa.conf bgpd/macros.conf \
  bgpd/prefix-permit.conf bgpd/prefix-deny.conf bgpd/prefix-mynetworks.conf

include mk/conf.inc

mk/bgp: ${CONF}
mk/bgp/sync:
mk/bgp/clean:
