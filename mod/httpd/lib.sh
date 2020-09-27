deploy_pre() { set -eu
	local acme=/etc/acme/letsencrypt-privkey.pem

	send "
		mkdir -p -m 700 /etc/acme
		test -f '$acme' || openssl genrsa -out '$acme'
	"
}
