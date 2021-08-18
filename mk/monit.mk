CONF = monitower.conf

include conf/mk/conf.mk

conf: monitower

monitower:
	exec ln -sf conf/monitower /etc
