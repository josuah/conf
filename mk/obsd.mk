CONF = login.conf newsyslog.conf relayd.conf relayd/tls.conf \
  pf.conf wireguard/hostname.if

include mk/conf.mk

conf: ${WIREGUARD:=obsd}

${WIREGUARD:=obsd}: ${@:obsd=} wireguard/hostname.if
	exec install -o0 -g0 -m600 /dev/null /etc/hostname.${@:obsd=}
	exec wg-obsd /etc/wireguard/${@:obsd=}.conf >>/etc/hostname.${@:obsd=}
	exec cat /etc/wireguard/hostname.if >>/etc/hostname.${@:obsd=}

wgpubkey:
	exec xargs ifconfig wg9999 create wgport 9999 wgkey </etc/wireguard/key
	exec ifconfig wg9999 | grep wgpubkey
	exec ifconfig wg9999 destroy
