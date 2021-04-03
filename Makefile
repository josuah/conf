HOSTS_CONF = shag corax pelios
HOSTS_HOME = bitreich.org server10.openbsd.amsterdam
PREFIX = /usr/local

all: home conf

home:
	sort -u -o home/.ssh/authorized_keys home/.ssh/authorized_keys
	cp -rf home/.??* "$$HOME"

conf:
	mkdir -p ${PREFIX}/bin
	cp -rf bin/* ${PREFIX}/bin

sync: ${HOSTS_CONF} ${HOSTS_HOME}

${HOSTS_CONF}:
	rsync -va --delete * $@:/etc/adm

${HOSTS_HOME}:
	rsync -va home/ $@:./

.PHONY: conf home
