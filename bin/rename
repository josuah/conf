#!/bin/sh -e
# rename files in batch using sed -i commands

pattern=$1
shift

for old in "$@"; do
	new=$(printf '%s\n' "$old" | sed -r "$pattern")
	echo "$new"
	mkdir -p "$(dirname "$new")"
	[ "$old" = "$new" ] || mv "$old" "$new"
done
