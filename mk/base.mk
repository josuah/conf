PREFIX = /usr/local

CONF = hosts syslog.conf crontab profile macros.conf ssh/sshd_config \
  ssh/ssh_config unbound.conf resolv.conf.tail inetd.conf
include conf/mk/conf.mk

home:
	cp -r conf/home/.??* ${HOME}

bin:
	make -C /etc/conf/bin

/home/pack:
	useradd -m pack

conf: pack
pack: /home/pack
	ln -sf ${PWD}/conf/pack /etc

conf: ssl/hostname.crt
ssl/hostname.crt:
	ln -sf /etc/ssl/$$(hostname).crt $@

conf: ssl/private/hostname.key
ssl/private/hostname.key:
	ln -sf /etc/ssl/private/$$(hostname).key $@

conf: ssh
	ssh-keygen -A
