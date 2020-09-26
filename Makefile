PREFIX = /usr/adm

install:
	mkdir -p ${PREFIX}${DESTDIR}/bin
	cp -r bin/* ${PREFIX}${DESTDIR}/bin

update: install
	mkdir -p local
	./bin/adm install
