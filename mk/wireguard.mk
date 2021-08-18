CONF = hostname.wg0 wireguard/wg0.conf

include conf/mk/conf.mk

hostname.wg0: wireguard/wg0.conf

wireguard/wg0.conf: /etc/wireguard/key

/etc/wireguard/key:
	openssl rand -base64 32 >$@
