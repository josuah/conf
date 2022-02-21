#!/bin/sh -e
# rename files in batch using sed -i commands

if [ "$1" = "-a" ]; then
	shift
	exec "$0" '
		s/[!-,[-`{-~ ]/-/g
		s/\.+/./g; s/-+/-/g; s/^-//; s/-$//
		s/\.-/-/g; s/-\././g; s/^-//
	' "$@"
fi

pattern=$1
shift

for old in "$@"; do
	new=$(printf '%s\n' "$old" | sed -r "$pattern")
	echo "$new"
	mkdir -p -- "$(dirname "$new")"
	[ "$old" = "$new" ] || mv -- "$old" "$new"
done
