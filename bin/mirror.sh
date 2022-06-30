#!/bin/sh -eu
set -o pipefail

trap 'rm -rf "$tmp"' INT TERM EXIT HUP

export LC_ALL=C

fmt='p%Mp%Lp m%m u%u g%g z%z	%N'
tmp=$(mktemp -d)

list() {
	cd "$1"
	find . -exec stat -f "$fmt" {} + | sort
}

(list "$1") >$tmp/1
(list "$2") >$tmp/2

if [ $(comm -3 "$tmp/1" "$tmp/2" | sed 1q | wc -l) -eq 0 ]; then
	echo "no difference" >&2
	exit
fi

comm -3 "$tmp/1" "$tmp/2" | awk '{
	sub(/^\t?[^\t]*\t/, "")
	if (!uniq[$0]++) {
		do {
			print $0
			print $0 >"/dev/stderr"
		} while (sub("/[^/]+$", ""))
	}
}' | (cd "$1" && tar -c -I- -f-) | (cd "$2" && tar -xp -f-)
