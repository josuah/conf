HOSTS_CONF = shag corax pelios
HOSTS_HOME = bitreich.org server10.openbsd.amsterdam
PREFIX = /usr/adm
ZONEDIR = /var/nsd/zones/master
RR = rr.soa rr.host rr.ns rr.mx rr.alias

all: init home

home:
	sort -u -o home/.ssh/authorized_keys home/.ssh/authorized_keys
	cp -rf home/.??* "$$HOME"

init:
	mkdir -p ${PREFIX}
	ln -sf $$PWD/bin ${PREFIX}

zone: zone/sshfp
	cd zone && DIR=${ZONEDIR} ${PWD}/bin/zone ${RR}
	cat zone/sshfp >>${ZONEDIR}/$$(sed q zone/rr.soa)

zone/sshfp: rr.host
	awk '!u[$$1]++ { print $$1 }' zone/rr.host | xargs -n1 ssh-keygen -r >$@

sync: ${HOSTS_CONF} ${HOSTS_HOME}

${HOSTS_CONF}:
	rsync -va --delete * $@:$$PWD

${HOSTS_HOME}:
	rsync -va home/ $@:./

.PHONY: conf home zone
