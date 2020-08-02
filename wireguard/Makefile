NAME = wireguard
CONF = conf.ini
ENV = /etc/env/sys/*

all: conf

conf: key
key: /etc/env/sys/WIREGUARD_PRIVATE_KEY
/etc/env/sys/WIREGUARD_PRIVATE_KEY:
	umask 600; wg genkey >$@

include ../Makefile.template
