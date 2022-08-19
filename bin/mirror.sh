#!/bin/sh -eu

src=$(readlink -f "$1")
dst=$(readlink -f "$2")

(cd "$dst" && find */ -type f) | while IFS= read -r path; do
	if [ ! -f "$dst/$path" ]; then
		mkdir -p "$dst/${path%*/}"
		cp -p "$src/$path" "$dst/$path"
	fi
done
