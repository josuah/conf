CONF = bgpd.conf bgpd/roa.conf bgpd/permit.conf bgpd/deny.conf ospf6d.conf
include conf/mk/conf.mk

conf: /home/bgplgsh ospf6d/local.conf

/home/bgplgsh:
	useradd -m -k /var/empty bgplgsh
	echo /usr/bin/bgplgsh >>shells

ospf6d/local.conf:
	mkdir -p -m 700 ${@D}
	install -m 600 /dev/null "$@"
