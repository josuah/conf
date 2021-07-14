#!/bin/sh -eu
# Jason Donfield's pass(1) alternative

key=$HOME/.ssh/id_ed25519

mkdir -p "$HOME/.password-store"
cd "$HOME/.password-store"

case ${1:-} in
(show)
	exec gpg2 -qad "$2"
	;;
(insert)
	if [ -e "$2" ]; then
		echo>&2 "password $2 already exist"
		exit 2
	fi
	mkdir -p "${2%/*}"
	exec gpg2 -qae -r "$EMAIL" >$2
	;;
(export)
	for x in */*; do
		"$0" show "$x" | awk -v id="$x" '{ print id, $0 }'
	done
	;;
(import)
	while read id pass; do
		echo "$pass" | "$0" insert "$id"
	done
	;;
("")
	file=$(find * -type f | dmenu -fn terminus:pixelsize=16 -p pass)
	"$0" show "$file" | tr -d '\n' | xsel -i
	echo "${file##*/}" | tr -d '\n' | xsel -bi
	;;
(-*)
	echo>&2 "usage:	${0##*/} [show|insert] resource/account-name"
	echo>&2 "	${0##*/} [import|export]"
	exit 1
	;;
(*)
	exec "$0" show "$@"
	;;
esac
