#!/bin/sh -eu
# acme-client without the need of a configuration file

exec acme-client -v -f /dev/stdin "$1" <<EOF

authority letsencrypt {
	api url "https://acme-v02.api.letsencrypt.org/directory"
	account key "/etc/acme/letsencrypt-privkey.pem"
}

authority letsencrypt-staging {
	api url "https://acme-staging-v02.api.letsencrypt.org/directory"
	account key "/etc/acme/letsencrypt-staging-privkey.pem"
}

domain "$1" {
	domain key "/etc/ssl/private/$1.key"
	domain full chain certificate "/etc/ssl/$1.crt"
	sign with letsencrypt
}

EOF
