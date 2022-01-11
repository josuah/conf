#!/bin/sh -eu
# host a file onto my server through scp

usage() {
	echo "usage: ${0##*} [-r rand] file" >&2
	exit 1
}

domain=paste.josuah.net
rand=${RAND:=$(openssl rand -base64 15 | tr '+/' 'az')}
paste=/var/www/htdocs/paste

ssh "$domain" "
	mkdir -p '$paste/$rand'
	touch '$paste/index.html'
"

scp "$@" "$domain:$paste/$rand/"
echo "https://$domain/$rand/"
