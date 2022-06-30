#!/bin/sh -eu

trap 'rm -rf "$tmp"' INT TERM EXIT HUP

fmt='p%Mp%Lp m%m u%u g%g z%z	%N'
tmp=$(mktemp -d)

list() {
	cd "$1"
	find . -type d -o -exec stat -f "$fmt" {} + | sort
}

(list "$1") >$tmp/1
(list "$2") >$tmp/2

diff -u "$tmp/1" "$tmp/2"
