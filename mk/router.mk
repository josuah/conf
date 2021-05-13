CONF = bgpd.conf bgpd/roa.conf bgpd/permit.conf bgpd/deny.conf ospf6d.conf

include mk/conf.mk

conf: /home/bgplgsh

/home/bgplgsh:
	exec useradd -m -k /var/empty bgplgsh
	exec echo /usr/bin/bgplgsh >>/etc/shells
