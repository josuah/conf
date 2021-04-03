HOSTS = shag corax pelios
PREFIX = /usr/local

install: home
	mkdir -p ${PREFIX}/bin
	cp -rf bin/* ${PREFIX}/bin

home:
	sort -u -o home/.ssh/authorized_keys home/.ssh/authorized_keys
	cp -rf home/.??* "$$HOME"

sync: ${HOSTS}
${HOSTS}:
	rsync -va --delete * $@:/etc/adm

.PHONY: home
