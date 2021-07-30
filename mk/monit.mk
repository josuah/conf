CONF = monitower.conf

include conf/mk/conf.mk

conf: monit

monit:
	exec cp -r conf/monitower /etc
