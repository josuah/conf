CONF = bgpd.conf bgpd/roa.conf bgpd/permit.conf bgpd/deny.conf ospf6d.conf

include conf/mk/conf.mk

conf: /home/bgplgsh ospf6d/local.conf

/home/bgplgsh:
	exec useradd -m -k /var/empty bgplgsh
	exec echo /usr/bin/bgplgsh >>shells

ospf6d/local.conf:
	exec mkdir -p -m 700 ${@D}
	exec install -m 600 /dev/null "$@"
