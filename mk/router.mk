CONF = bgpd.conf bgpd/roa.conf bgpd/permit.conf bgpd/deny.conf ospf6d.conf
include mk/conf.inc

mk/router: ${CONF}
mk/router/sync:
mk/router/clean:
