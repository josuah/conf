deploy_post() { set -eu
	send "printf 'include \"%s\"\n' /etc/relayd/* >>/etc/relayd.conf"
}
