#!/bin/sh -eu
set -o pipefail

trap 'rm -rf "$tmp"' INT TERM EXIT HUP

export LC_ALL=C

fmt='p%Mp%Lp m%m u%u g%g z%z	%N'
tmp=$(mktemp -d)

list() {
	cd "$1"
	find . ! -type d -exec stat -f "$fmt" {} + | sort
}

mkdir -p "$2"
(list "$1") >$tmp/1
(list "$2") >$tmp/2

if [ $(comm -3 "$tmp/1" "$tmp/2" | sed 1q | wc -l) -eq 0 ]; then
	echo "no difference" >&2
	exit
fi

comm -3 "$tmp/1" "$tmp/2" | while IFS='	' read -r info file; do
	echo "$1 -> $2 ... ${file#./}"
	mkdir -p "$2/${file%/*}"
	cp -p "$1/$file" "$2/$file"
done
