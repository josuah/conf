
deploy_pre() { set -eu
	cat /etc/inetd.d/* >/etc/inetd.conf
}
