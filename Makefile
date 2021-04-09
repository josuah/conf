PREFIX = /usr/local
SYNC_CONF = shag corax pelios
SYNC_HOME = root@shag root@corax josuah@corax root@pelios josuah@shag \
  josuah@bitreich.org josuah@server10.openbsd.amsterdam
CONF_BASE = hosts syslog.conf crontab profile

CONF_DNS = nsd/nsd.conf
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

dns: ${CONF_DNS}
	rm -rf /var/nsd/zones
	mkdir -p /var/nsd
	cp -r zones /var/nsd

http: ${CONF_HTTP}

mail: ${CONF_MAIL}

monit: ${CONF_MONIT}

tls: ${CONF_TLS}

${CONF_BASE} ${CONF_DNS} ${CONF_HTTP} ${CONF_MAIL} ${CONF_MONIT} ${CONF_TLS}:
	bin/template conf/$@ >/etc/$@

sync: ${SYNC_CONF} ${SYNC_HOME}

${SYNC_CONF}:
	rsync -vr --delete * $@:${PWD}

${SYNC_HOME}:
	rsync -vr home/ $@:./

zones: rrdata sshfp
	mkdir -p zones
	cd zones && rrzone ${PWD}/rrdata
	cat sshfp >>zones/$$(awk '$$1=="$$MAIN" {print$$2}' rrdata).zone

sshfp: rrdata
	ssh-keyscan -D $$(awk '$$3=="HOST" && !uniq[$$4]++ {print$$4}' rrdata) \
	 | sort -u -o $@

sign zsk ksk: zones
	for zone in zones/*.zone; do dnssec $@ "$$zone"; done

clean:
	rm -f zones/*

.PHONY: home zones pack wire
