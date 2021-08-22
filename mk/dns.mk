CONF = nsd.conf

include conf/mk/conf.mk

nsd.conf: /var/nsd/etc/nsd.conf

/var/nsd/etc/nsd.conf:
	touch $@
	ln -sf $@ nsd.conf
