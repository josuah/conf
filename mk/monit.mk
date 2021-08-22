CONF = monitower.conf

include conf/mk/conf.mk

conf: monitower

monitower:
	ln -sf conf/monitower .
