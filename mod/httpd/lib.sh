deploy_pre() { set -eu
	local acme=/etc/acme/letsencrypt-privkey.pem

        send "ls /etc/ssl/acme" | sed 's,^,dom=,' >$etc/host/$host/db.cert

	send "	mkdir -p /etc/acme
		test -f '$acme' || openssl genrsa -out '$acme'
	"
}
