CONF = hostname.wg0 wireguard/wg0.conf

include conf/mk/conf.mk

hostname.wg0: wireguard/wg0.conf

wireguard/wg0.conf: wireguard/key

wireguard:
	exec mkdir -p -m 007 $@

wireguard/key:
	exec openssl rand -base64 32 >$@
