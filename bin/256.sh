#!/bin/sh
# set read-only and deduplicate all files found on the current directory
set -eu -o pipefail

find="find . -xdev -path ./.256 -prune -o ! -name '*.core' -type f"

case $1 in
(store)
	mkdir -p .256/rev
	$find -exec openssl sha256 -r {} + | sed 's/ \*/	/' >.256/tmp
	rev=$(openssl sha256 -r .256/tmp | sed 's/ .*//')
	sed 's,...,.256/&/&,' .256/tmp | while IFS='	' read -r hash file; do
		mkdir -p "${hash%/*}"
		if [ -f "$hash" ]; then
			ln -f "$hash" "$file"
		else
			ln -f "$file" "$hash"
		fi
	done
	mv -f ".256/tmp" ".256/rev/$rev"
	date +"%Y-%m-%d %H:%M:%S $rev" >>.256/log
	find * .256/*/ -type f -exec chmod -w {} +
	tail .256/log
	;;
(expand) rev=$2
	sed 's/.../&	&/' ".256/rev/$rev" | while IFS='	' read -r h hash path; do
		mkdir -p "${path%/*}"
		ln -f ".256/$h/$hash" "$path"
	done
	;;
(*)
	sed -rn "s/=\\\$[0-9]+//g; s/^\(([a-z]+)\)/${0##*/} \1/p" "$0" >&2
	exit 1
	;;
esac
