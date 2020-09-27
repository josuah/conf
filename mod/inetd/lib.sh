deploy_pre() { set -eu
	send "cat /etc/inetd.d/* >/etc/inetd.conf"
}
