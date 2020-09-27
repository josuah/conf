deploy_post() { set -eu
	send "printf 'include \"%s\"\n' /etc/relayd.d/* >>/etc/relayd.conf"
}
