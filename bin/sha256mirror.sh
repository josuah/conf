#!/bin/sh -eu

src=$(readlink -f "$1/sha256/")
dst=$(readlink -f "$2/sha256/")

(cd "$dst" && find */ -type f) | while IFS= read -r path; do
	if [ ! -f "$dst/$path" ]; then
		mkdir -p "$dst/${path%*/}"
		cp "$src/$path" "$dst/$path"
	fi
done

chmod -R -w "$dst"/*/
