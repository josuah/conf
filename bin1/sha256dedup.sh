#!/bin/sh -eu
# set read-only and deduplicate all files found on the current directory

find . -name '*.core' -delete # mpv crash workaround
find . -xdev -type f -exec chmod -w {} + -exec openssl sha256 -r {} + \
| sed 's, \*,	,; s,...,sha256/&/&,' \
| while IFS='	' read -r hash file; do
	mkdir -p "${hash%/*}"
	[ -f "$hash" ] && ln -f "$hash" "$file" || ln -f "$file" "$hash"
done
find sha256 -type f -exec chmod -w {} +
