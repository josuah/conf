deploy_post() { set -eu
	send "
		chmod 700 /etc/wireguard
	"
}
