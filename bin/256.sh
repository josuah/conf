#!/bin/sh
# set read-only and deduplicate all files found on the current directory
set -eu -o pipefail

find="find . -xdev -path ./.256 -prune -o ! -name '*.core' -type f"

case $1 in
(store)
	mkdir -p .256/rev .256/obj
	$find -exec openssl sha256 -r {} + | sed 's/ \*/	/' >.256/tmp
	rev=$(openssl sha256 -r .256/tmp | sed 's/ .*//')
	while IFS='	' read -r hash file; do
		if [ -f ".256/obj/$hash" ]; then
			echo "$hash $file"
			ln -f ".256/obj/$hash" "$file"
		else
			ln -f "$file" ".256/obj/$hash"
		fi
	done <.256/tmp
	mv -f ".256/tmp" ".256/rev/$rev"
	date +"%Y-%m-%d %H:%M:%S $rev" >>.256/log
	find . -type f -exec chmod -w {} +
	tail .256/log
	;;
(expand) rev=$2
	while IFS='	' read -r hash path; do
		mkdir -p "${path%/*}"
		ln -f ".256/obj/$hash" "$path"
	done <.256/rev/$rev
	;;
(*)
	sed -rn "s/=\\\$[0-9]+//g; s/^\(([a-z]+)\)/${0##*/} \1/p" "$0" >&2
	exit 1
	;;
esac
