PREFIX = /usr/local

install:
	mkdir -p ${PREFIX}/bin
	cp -rf bin/* ${PREFIX}/bin

dot:
	cp -rf dot/.* ${HOME}

sync:
	rsync -va --delete * ${HOST}:/etc/adm

ssh:

.PHONY: ssh dot
