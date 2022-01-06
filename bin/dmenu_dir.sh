#!/bin/sh -e

path=$(readlink -f "${1:-.}")

while :; do
	sel=$(ls -ap "$path" | dmenu -p "${path%/}/")
	test -n "$sel"

	path=$(readlink -f "$path/$sel")
	if [ "$sel" = "./" -o -f "$path" ]; then
		exec echo "$path"
	fi
done
