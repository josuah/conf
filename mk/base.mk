PREFIX = /usr/local

CONF = mail/smtpd.conf mail/aliases mail/domains hosts syslog.conf \
 crontab profile macros.conf ssh/sshd_config ssh/ssh_config \
 resolv.conf.tail

include conf/mk/conf.mk

conf: /etc/pack /etc/ssl/hostname.crt /etc/ssl/private/hostname.key

/home/pack:
	exec useradd -m pack

/etc/pack: /home/pack
	exec ln -sf ${PWD}/conf/pack /etc

/etc/ssl/hostname.crt:
	exec ln -sf /etc/ssl/$$(hostname).crt $@

/etc/ssl/private/hostname.key:
	exec ln -sf /etc/ssl/private/$$(hostname).key $@
