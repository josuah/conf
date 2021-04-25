CONF = monitower.conf
include mk/conf.inc

mk/monit: ${CONF}
	exec cp -r conf/monitower /etc

mk/monit/sync:
mk/monit/clean:
