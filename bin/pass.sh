#!/bin/sh -eu
# Jason Donfield's pass(1) alternative

key=$HOME/.ssh/id_ed25519

mkdir -p "$HOME/.password-store"
cd "$HOME/.password-store"

case ${1:-menu} in
(show) pass=$2
	exec age -d -i "$key" "$pass"
	;;
(insert) pass=$2
	mkdir -p "${pass%/*}"
	exec age -e -a -R "$key.pub" >$2
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
(menu)
	file=$(find * -type f | dmenu -p pass:)
	"$0" show "$file" | tr -d '\n' | xsel -i
	echo "${file##*/}" | tr -d '\n' | xsel -bi
	;;
(-*)
	sed -rn "s/=\\\$[0-9]+//g; s/^\(([a-z]+)\)/${0##*/} \1/p" "$0" >&2
	exit 1
	;;
(*)
	exec "$0" show "$@"
	;;
esac
