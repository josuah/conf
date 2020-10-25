deploy_pre() { set -eu
	send "ls /etc/ssl/*.crt" | sed 's,.*/,dom=,; s,.crt$,,' >tmp/cert
}

deploy_post() { set -eu
	local acme=/etc/acme/letsencrypt-privkey.pem

	send "
		mkdir -p -m 700 /etc/acme /etc/ssl/private
		test -f '$acme' || openssl genrsa -out '$acme'

		printf 'include \"%s\"\n' /etc/httpd/* >>/etc/httpd.conf

		printf 'include \"%s\"\n' /etc/relayd/* >/etc/relayd.conf
	"
}
