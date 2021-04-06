PREFIX = /usr/local
SYNC_CONF = shag corax pelios
SYNC_HOME = root@shag root@corax josuah@corax root@pelios josuah@shag \
  josuah@bitreich.org josuah@server10.openbsd.amsterdam
CONF_BASE = hosts syslog.conf crontab profile
CONF_HTTP = httpd.conf
CONF_MAIL = mail/smtpd.conf
CONF_MONIT = monitower.conf
CONF_TLS = relayd.conf

all: home pack base

home:
	cp -r home/.??* ${HOME}

pack:
	mkdir -p /home/pack
	ln -s "${PWD}/pack" recipe
	mv recipe /home/pack

base: ${CONF_BASE}
	mkdir -p ${PREFIX}/bin
	ln -sf ${PWD}/bin/* ${PREFIX}/bin

http: ${CONF_HTTP}

mail: ${CONF_MAIL}

monit: ${CONF_MONIT}

tls: ${CONF_TLS}

${CONF_BASE} ${CONF_HTTP} ${CONF_MAIL} ${CONF_MONIT} ${CONF_TLS}:
	bin/template conf/$@ >/etc/$@

sync: ${SYNC_CONF} ${SYNC_HOME}

${SYNC_CONF}:
	rsync -vr --delete * $@:${PWD}

${SYNC_HOME}:
	rsync -vr home/ $@:./

zone: rrdata sshfp
	mkdir -p zone
	cd zone && rrzone ${PWD}/rrdata
	cat sshfp >>zone/$$(awk '$$1=="$$MAIN" {print$$2}' rrdata).zone

sshfp: rrdata
	mkdir -p zone
	awk '$$3 == "HOST" && !uniq[$$1]++ { print$$1 }' rrdata \
	 | xargs -n1 ssh-keygen -r >$@

sign zsk ksk: zone
	for zone in zone/*.zone; do dnssec $@ "$$zone"; done

clean:
	rm -f zone/*

.PHONY: home zone pack
