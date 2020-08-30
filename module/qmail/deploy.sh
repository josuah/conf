#!/bin/sh -eux

link() {
	ln -s "$1" "$tmp/$(basename "$2")"
	mkdir -p "$(dirname "$2")"
	mv "$tmp/$(basename "$2")" "$(dirname "$2")"
}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' INT TERM EXIT HUP

mkdir -p "/etc/qmail/control"
hostname >/etc/qmail/control/me

mkdir -p /var/qmail
link	/etc/qmail/control	/var/qmail/control
link	/etc/qmail/alias	/var/qmail/alias
link	/etc/qmail/users	/var/qmail/users
link	/var/spool/qmail	/var/qmail/queue
link	/usr/adm/bin		/var/qmail/bin
