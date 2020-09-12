PREFIX = /usr/adm

install:
	mkdir -p ${PREFIX}${DESTDIR}/bin
	cp -r bin/* ${PREFIX}${DESTDIR}/bin
	mkdir -p ${PREFIX}${DESTDIR}/lib/adm
	cp -r lib/* ${PREFIX}${DESTDIR}/lib
