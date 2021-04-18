CONF = hosts syslog.conf crontab profile relayd.conf
include mk/conf.inc

mk/base: ${CONF} /etc/ssl/hostname.crt /etc/ssl/private/hostname.key
	exec mkdir -p ${PREFIX}/bin
	exec ln -sf ${PWD}/bin/* ${PREFIX}/bin

/etc/ssl/hostname.crt:
	exec ln -sf /etc/ssl/$$(hostname).crt /etc/ssl/hostname.crt

/etc/ssl/private/hostname.key:
	exec ln -sf /etc/ssl/private/$$(hostname).key /etc/ssl/private/hostname.key

mk/base/sync:
mk/base/clean:
