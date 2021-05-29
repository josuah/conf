conf: ${WIREGUARD}

${WIREGUARD}: /etc/wireguard/key
	exec env ${ENV} wg-ptp conf/wireguard/$@.conf >/etc/wireguard/$@.conf

/etc/wireguard/key:
	exec mkdir -p -m 700 ${@D}
	exec openssl rand -base64 32 >$@
