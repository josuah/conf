deploy_post() { set -eu
	send "
		printf '\n  %s\n\n' \"\$(uname -srnm)\" >/etc/motd

		mkdir -p /var/unbound/db
		chown _unbound: /var/unbound/db
		unbound-anchor -vvv -a /var/unbound/db/root.key

		sh /etc/adm.sh

		mkdir -p '$usr'
	"

	scp -qr "$bin" "root@$host:$usr"
}
