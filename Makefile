PREFIX = /usr/local

install:
	mkdir -p ${PREFIX}/bin
	cp -rf bin/* ${PREFIX}/bin

dotfiles:
	cp -rf dot/.* ${HOME}

push:
	while read host; do
		git archive | ssh "$host" "mkdir -p /etc/adm
	done
