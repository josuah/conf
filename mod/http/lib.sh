deploy_pre() { set -eu
	dbase "$db/dns-alias" get dom soa host \
	| while IFS='	' read dom soa host; do
		case "$dom" in (*"*"*) ;;
		(@) echo host="$host" dom="$soa" ;;
		(*) echo host="$host" dom="$dom.$soa" ;;
		esac
	done >tmp/cert
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
