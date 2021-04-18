BASE = shag corax pelios
CONF = hosts syslog.conf crontab profile httpd.conf mail/smtpd.conf relayd.conf
include mk/conf.inc

mk/base: ${CONF}
	exec mkdir -p ${PREFIX}/bin /home/pack
	exec ln -sf ${PWD}/bin/* ${PREFIX}/bin
	exec ln -sf "${PWD}/recipe" /home/pack
	exec ln -sf /etc/ssl/$$(hostname).crt /etc/ssl/hostname.crt
	exec ln -sf /etc/ssl/private/$$(hostname).key /etc/ssl/private/hostname.key

mk/base/sync: ${BASE}
${BASE}:
	exec rsync -vrt --delete ${PWD}/* $@:${PWD}

mk/base/clean:

.PHONY: home
