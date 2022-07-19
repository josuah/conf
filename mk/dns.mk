conf: /var/nsd/etc/nsd.conf

/var/nsd/etc/nsd.conf:
	template env=Makefile conf/nsd.conf >$@
