CONF = hosts syslog.conf crontab profile macros.conf
include mk/conf.inc

mk/base: ${CONF} ${PREFIX}/bin /home/pack/recipe \
/etc/ssl/hostname.crt /etc/ssl/private/hostname.key
	exec ln -sf ${PWD}/bin/* ${PREFIX}/bin
	exec env ${ENV} wg-ptp wire/*

mk/base/sync:
mk/base/clean:

${PREFIX}/bin:
	exec mkdir -p ${PREFIX}/bin

/home/pack:
	exec useradd -m pack

/home/pack/recipe: /home/pack
	exec ln -sf "${PWD}/recipe" /home/pack

/etc/ssl/hostname.crt:
	exec ln -sf /etc/ssl/$$(hostname).crt /etc/ssl/hostname.crt

/etc/ssl/private/hostname.key:
	exec ln -sf /etc/ssl/private/$$(hostname).key /etc/ssl/private/hostname.key
