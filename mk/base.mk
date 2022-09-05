PREFIX = /usr/local
RSSH = josuah@bitreich.org josuah@server10.openbsd.amsterdam
CONF =	hosts syslog.conf crontab profile ssh/authorized_keys \
	ssh/sshd_config ssh/ssh_config unbound.conf resolv.conf.tail inetd.conf
include conf/mk/conf.mk

home:
	cp -r conf/home/.??* ${HOME}

bin:
	make -C /etc/conf/bin

/home/pack:
	useradd -m pack

conf: pack
pack: /home/pack
	ln -sf /etc/conf/pack /etc

conf: ssh
	ssh-keygen -A

rssh: ${RSSH}
${RSSH}:
	scp /etc/conf/ssh/authorized_keys $@:.ssh/authorized_keys

sync: ${SYNC}
${SYNC}:
	rsync -lvrt --delete conf/* $@:/etc/conf/
	ssh $@ make -C /etc
