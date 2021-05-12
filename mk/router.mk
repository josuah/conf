CONF = bgpd.conf bgpd/roa.conf bgpd/permit.conf bgpd/deny.conf ospf6d.conf
include mk/conf.mk

mk/router: /home/bgplgsh
mk/router/sync:

/home/bgplgsh:
	exec useradd -m -k /var/empty bgplgsh
	exec echo /usr/bin/bgplgsh >>/etc/shells
