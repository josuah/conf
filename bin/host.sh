#!/bin/sh -eu
# host a file onto my server through scp

usage() {
	echo "usage: ${0##*} [-a] [-r rand] file" >&2
	exit 1
}

domain=paste.josuah.net
rand=${RAND:=$(openssl rand -base64 15 | tr '+/' 'az')}
paste=/var/www/htdocs/paste

case $1	in
(-a)
	rand=$(ssh "$domain" "ls -td '$paste/'*/" | sed 's,/$,,; s,.*/,,; q')
	shift
	;;
(-r)
	rand=$2
	shift 2
	;;
esac

ssh "$domain" "
	mkdir -p '$paste/$rand'
	touch '$paste/index.html'
"

scp "$@" "$domain:$paste/$rand/"
echo "https://$domain/$rand/"
