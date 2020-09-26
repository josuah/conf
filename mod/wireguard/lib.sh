
deploy_post() { set -eu
	local key=

	send "
		cd /etc/wireguard
		umask 400
		[ -f key ] || echo PrivateKey = \$(wg genkey) >key
		cat peers interface key >conf
	"
}
