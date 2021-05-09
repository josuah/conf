CONF = monitower.conf
include mk/conf.mk

mk/monit:
	exec cp -r conf/monitower /etc

mk/monit/sync:
