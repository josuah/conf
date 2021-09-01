PREFIX = /usr/local

CONF = mail/smtpd.conf mail/aliases mail/domains hosts syslog.conf \
 crontab profile macros.conf ssh/sshd_config ssh/ssh_config \
 unbound.conf resolv.conf.tail inetd.conf

include conf/mk/conf.mk

conf: pack ssl/hostname.crt ssl/private/hostname.key

home:
	cp -r conf/home/.??* ${HOME}

bin:
	make -C /etc/conf/bin

/home/pack:
	useradd -m pack

pack: /home/pack
	ln -sf ${PWD}/conf/pack /etc

ssl/hostname.crt:
	ln -sf /etc/ssl/$$(hostname).crt $@

ssl/private/hostname.key:
	ln -sf /etc/ssl/private/$$(hostname).key $@
