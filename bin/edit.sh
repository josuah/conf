#!/bin/sh -eu

editor=/usr/local/bin/vi

edit_ssh_make() {
	file=$(echo "$2" | tr -d "'") # security
	ssh -t ams1 "cd '$1' && $editor './$file' && exec make"
}

case $1 in
(https://josuah.net/*)
	edit_ssh_make /var/www/htdocs/josuah-home "${1#https://*/}/index.md"
	;;
(https://panoramix-labs.fr/*)
	edit_ssh_make  /var/www/htdocs/panoramix-labs "${1#https://*/}/index.md"
	;;
(*)
	echo "unable to edit $x" >/dev/stderr
	exit 1
	;;
esac
