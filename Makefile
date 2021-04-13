PREFIX = /usr/local
SYNC_CONF = shag corax pelios laptop-p-g
SYNC_HOME = root@shag root@corax josuah@corax root@pelios josuah@shag \
  josuah@bitreich.org josuah@server10.openbsd.amsterdam root@laptop-p-g
CONF_BASE = hosts syslog.conf crontab profile

CONF_DNS = nsd/nsd.conf
CONF_HTTP = httpd.conf
CONF_MAIL = mail/smtpd.conf
CONF_MONIT = monitower.conf
CONF_TLS = relayd.conf

ZONE_MAIN = z0.is z0.dn42

all: home pack base

home:
	exec cp -r home/.??* ${HOME}

pack:
	exec mkdir -p /home/pack
	exec ln -s "${PWD}/pack" recipe
	exec mv recipe /home/pack

base: ${CONF_BASE}
	exec mkdir -p ${PREFIX}/bin
	exec ln -sf ${PWD}/bin/* ${PREFIX}/bin

dns: ${CONF_DNS}
	exec rm -rf /var/nsd/zones
	exec mkdir -p /var/nsd
	exec cp -r zones /var/nsd/zones

http: ${CONF_HTTP}

mail: ${CONF_MAIL}

monit: ${CONF_MONIT}

tls: ${CONF_TLS}

${CONF_BASE} ${CONF_DNS} ${CONF_HTTP} ${CONF_MAIL} ${CONF_MONIT} ${CONF_TLS}:
	exec bin/template conf/$@ >/etc/$@

sync: ${SYNC_CONF} ${SYNC_HOME}

${SYNC_CONF}:
	exec rsync -vr --delete * $@:${PWD}

${SYNC_HOME}:
	exec rsync -vr home/ $@:./

zone: ${ZONE_MAIN} ${ZONE_EXTRA}

zone/out:
	exec mkdir -p zone/out

zone: zone/out zone/sshfp.zone
	cd zone && nsdom=$@ template %head.zone | zone $@.zone >out/$@.zone
	cd zone && exec cat sshfp.zone >>out/$@.zone

zone/sshfp.zone:
	ssh-keyscan -D $$(awk '$$3=="A"||$$3=="AAAA" && !uniq[$$4]++ {print$$4}' zones/*.zone) \
	 | sort -u -o $@

sign zsk ksk: zones
	for zone in zones/*.zone; do dnssec $@ "$$zone"; done

clean:
	exec rm -f zone/out/*

.PHONY: home zones pack wire
