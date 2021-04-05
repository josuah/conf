CONF_BASE = hosts syslog.conf
CONF_MAIL = mail/smtpd.conf
CONF_HTTP = httpd.conf
CONF_TLS = relayd.conf
HOST_CONF = shag corax pelios
HOST_HOME = bitreich.org server10.openbsd.amsterdam
PREFIX = /usr/adm
ZONEDIR = /var/nsd/zones/master
RR = rr.soa rr.host rr.ns rr.mx rr.alias

all: base home

home:
	sort -u -o home/.ssh/authorized_keys home/.ssh/authorized_keys
	cp -rf home/.??* "$$HOME"

zone: zone/sshfp
	cd zone && DIR=${ZONEDIR} ${PWD}/bin/zone ${RR}
	cat zone/sshfp >>${ZONEDIR}/$$(sed q zone/rr.soa)
zone/sshfp: zone/rr.host
	awk '!u[$$1]++ { print $$1 }' zone/rr.host | xargs -n1 ssh-keygen -r >$@

sync: ${HOST_CONF} ${HOST_HOME}
${HOST_CONF}:
	rsync -va --delete * $@:$$PWD
${HOST_HOME}:
	rsync -va home/ $@:./

base: ${CONF_BASE}
	mkdir -p ${PREFIX}
	ln -sf $$PWD/bin ${PREFIX}
http: ${CONF_HTTP}
mail: ${CONF_MAIL}
tls: ${CONF_TLS}

${CONF_BASE} ${CONF_HTTP} ${CONF_MAIL} ${CONF_TLS}:
	bin/template conf/$@ >/etc/$@

.PHONY: base home zone
