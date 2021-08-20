PREFIX = /usr/local

CONF = mail/smtpd.conf mail/aliases mail/domains hosts syslog.conf \
 crontab profile macros.conf ssh/sshd_config ssh/ssh_config \
 resolv.conf.tail inetd.conf

include conf/mk/conf.mk

conf: pack ssl/hostname.crt ssl/private/hostname.key

/home/pack:
	exec useradd -m pack

pack: /home/pack
	exec ln -sf ${PWD}/conf/pack /etc

ssl/hostname.crt:
	exec ln -sf /etc/ssl/$$(hostname).crt $@

ssl/private/hostname.key:
	exec ln -sf /etc/ssl/private/$$(hostname).key $@
