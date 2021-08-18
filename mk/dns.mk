CONF = nsd.conf

include conf/mk/conf.mk

nsd.conf: /var/nsd/etc/nsd.conf

/var/nsd/etc/nsd.conf:
	exec touch /var/nsd/etc/$@
	exec ln -s /var/nsd/etc/$@ /etc/$@
