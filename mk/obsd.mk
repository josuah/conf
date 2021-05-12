CONF = login.conf newsyslog.conf relayd.conf relayd/tls.conf \
  wireguard/hostname.if
include mk/conf.mk

mk/obsd: ${WGPEERS}
mk/obsd/sync:

${WGPEERS}: wireguard/hostname.if
	exec wg-obsd /etc/wireguard/$@.conf >/etc/hostname.$@
	exec cat /etc/wireguard/hostname.if >>/etc/hostname.$@
