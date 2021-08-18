CONF = nsd.conf

include conf/mk/conf.mk

nsd.conf: /var/nsd/etc/nsd.conf

/var/nsd/etc/nsd.conf:
	exec touch $@
	exec ln -sf $@ nsd.conf
