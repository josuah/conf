PREFIX = /usr/adm
RR = rr.soa rr.host rr.ns rr.mx rr.alias rr.data
ZONEDIR = /var/nsd/zones/master

SYNC_CONF = shag corax pelios
SYNC_HOME = shag corax pelios josuah@shag bitreich.org server10.openbsd.amsterdam

CONF_BASE = hosts syslog.conf crontab
CONF_HTTP = httpd.conf
CONF_MAIL = mail/smtpd.conf
CONF_MONIT = monitower.conf
CONF_TLS = relayd.conf

all: base home

home:
	cp -r home/.??* ${HOME}

zone: zone/sshfp
	cd zone && DIR=${ZONEDIR} ${PWD}/bin/zone ${RR}
	cat zone/sshfp >>${ZONEDIR}/$$(awk 'NR == 1 { print $$1 }' zone/rr.soa)
zone/sshfp: zone/rr.host
	awk '!u[$$1]++ { print $$1 }' zone/rr.host | xargs -n1 ssh-keygen -r >$@

sync: ${SYNC_CONF} ${SYNC_HOME}

${SYNC_CONF}:
	rsync -va --delete * $@:${PWD}

${SYNC_HOME}:
	rsync -va home/ $@:./

${CONF_BASE} ${CONF_HTTP} ${CONF_MAIL} ${CONF_MONIT} ${CONF_TLS}:
	bin/template conf/$@ >/etc/$@

base: ${CONF_BASE}
	mkdir -p ${PREFIX}
	ln -sf ${PWD}/bin ${PREFIX}

http: ${CONF_HTTP}
mail: ${CONF_MAIL}
monit: ${CONF_MONIT}
tls: ${CONF_TLS}

.PHONY: home zone
