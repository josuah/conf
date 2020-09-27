deploy_pre() { set -eu
	local acme=/etc/acme/letsencrypt-privkey.pem

	send "
		mkdir -p -m 700 /etc/acme /etc/ssl/private
		test -f '$acme' || openssl genrsa -out '$acme'
	"
}
