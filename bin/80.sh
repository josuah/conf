#!/bin/sh -eu

case "$1" in
(mk)
	sed 's/ \\$//'
	xargs | fold -ws 70 | sed 's/^/	/; s/$/\\/; $ s/\\$//'
	;;
esac

