CONF = login.conf newsyslog.conf relayd.conf
include mk/conf.inc

mk/obsd: ${CONF}
	exec tee /etc/hostname.wg* </dev/null
	exec wg-obsd /etc/wireguard/wg*.conf
	${ENV}; exec printf '\n%s\n' "inet6 fe80::$$hostid/64" "up" \
	 | tee -a /etc/hostname.wg* >/dev/null

mk/obsd/sync:
mk/obsd/clean:
