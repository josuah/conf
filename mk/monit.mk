CONF = monitower.conf

include mk/conf.mk

conf: monit

monit:
	exec cp -r conf/monitower /etc
