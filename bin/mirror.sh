#!/bin/sh -eu

mkdir -p "$2"
src=$(readlink -f "$1")
dst=$(readlink -f "$2")
shift 2

(cd "$src" && find . -type f "$@") | while IFS= read -r path; do
	if [ ! -f "$dst/$path" ]; then
		echo "$path"
		mkdir -p "$dst/${path%/*}"
		tmp=$(mktemp -p "$dst")
		cp "$src/$path" "$tmp"
		mv "$tmp" "$dst/$path"
	fi
done
