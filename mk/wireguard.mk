CONF = hostname.wg0 wireguard/wg0.conf
include conf/mk/conf.mk

hostname.wg0: wireguard/wg0.conf

wireguard/wg0.conf: wireguard/key

wireguard:
	mkdir -p -m 007 $@

wireguard/key:
	openssl rand -base64 32 >$@
