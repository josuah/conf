HOSTS_CONF = shag corax pelios
HOSTS_HOME = bitreich.org server10.openbsd.amsterdam
PREFIX = /usr/adm
RR = rr.soa rr.host rr.ns rr.mx rr.alias

all: init home

home:
	sort -u -o home/.ssh/authorized_keys home/.ssh/authorized_keys
	cp -rf home/.??* "$$HOME"

init:
	mkdir -p ${PREFIX}
	ln -sf $$PWD/bin ${PREFIX}

zone:
	cd zone && DIR=/var/nsd/zones/master ${PWD}/bin/zone ${RR}

sync: ${HOSTS_CONF} ${HOSTS_HOME}

${HOSTS_CONF}:
	rsync -va --delete * $@:$$PWD

${HOSTS_HOME}:
	rsync -va home/ $@:./

.PHONY: conf home zone
