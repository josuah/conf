deploy_post() { set -eu
	send "
		touch '$HOME/.ssh/config_local'

		mkdir -p /var/unbound/db
		chown _unbound: /var/unbound/db
		unbound-anchor -vvv -a /var/unbound/db/root.key

		mkdir -p '$usr'

		sh -eu /etc/adm.reconf
		sh -eu /etc/adm.reload
	"

	scp -qr "$bin" "root@$host:$usr"
}
