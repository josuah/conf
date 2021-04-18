CONF = nsd/nsd.conf
include mk/conf.inc

mk/dns: ${CONF}
	exec rm -rf /var/nsd/zones
	exec mkdir -p /var/nsd
	exec cp -r zones /var/nsd
	exec nsd-control reload

mk/dns:
mk/dns/sync:
