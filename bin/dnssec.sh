#!/bin/sh -eu
# wrapper over ldns-keygen to automate DNSSEC deployment

zone=${2:-}
origin=$(awk '$1 == "$ORIGIN" { print $2 }' "$zone")

case "$*" in
("zsk "*)
	mkdir -p -m 700 "/etc/dnssec/$origin+zsk"
	cd "/etc/dnssec/$origin+zsk"
	ldns-keygen -a ECDSAP256SHA256 -b 4096 -r /dev/urandom "$origin" >>log
	;;
("ksk "*)
	mkdir -p -m 700 "/etc/dnssec/$origin+ksk"
	cd "/etc/dnssec/$origin+ksk"
	ldns-keygen -k -a ECDSAP256SHA256 -b 4096 -r /dev/urandom "$origin" >>log
	;;
("sign "*)
	zsk=/etc/dnssec/$origin+zsk/$(tail -n 1 /etc/dnssec/$origin+zsk/log)
	ksk=/etc/dnssec/$origin+ksk/$(tail -n 1 /etc/dnssec/$origin+ksk/log)
	salt=$(openssl rand -hex 64)
	ldns-signzone -n -s "$salt" "$zone" "$ksk" "$zsk" >$zone.signed
	;;
("sshfp "*)
	awk '/[ \t](A|AAAA)[ \t]/ && !uniq[$1]++ { print $1 }' "$zone" \
	 | sort | xargs ssh-keyscan -D
	;;
("info "*)
	ksk=/etc/dnssec/$origin+ksk/$(tail -n 1 /etc/dnssec/$origin+ksk/log)
	awk '{ print "tag="$4" algo="$5" type="$6" digest="$7 }' "$ksk.ds"
	awk '{ print "key="$7 }' "$ksk.key"
	;;
(*)
	echo>&2 "usage:	${0##*/} (ksk|zsk|sign) zonefile" >&2
	exit 1
	;;
esac
