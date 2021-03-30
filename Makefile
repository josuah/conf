HOSTS = shag corax pelios
PREFIX = /usr/local

install:
	mkdir -p ${PREFIX}/bin
	cp -rf bin/* ${PREFIX}/bin

dot:
	cp -rf dot/.* ${HOME}

sync: ${HOSTS}
${HOSTS}:
	rsync -va --delete * $@:/etc/adm

ssh:

.PHONY: ssh dot
