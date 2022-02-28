#!/bin/sh -eu
# nimble source-based package manager for custom build recipes

download_http() {
	if [ ! -f "$cache-$v.$1" ]
	then exec curl -L -o "$cache-$v.$1" "$2"
	fi
}

download_git() {
	if [ -d "$cache.git" ]
	then exec git clone --depth 1 --branch "$v" "$url" ".cache/$name.git"
	else exec git -C ".cache/$name.git" fetch
	fi
}

pack_download() {
	case $url in
	(*.tgz|*.tar.gz)
		download_http tgz "$url"
		gzip -cd "$cache-$v.tgz" | tar -xf-
		;;
	(*.txz|*.tar.xz)
		download_http txz "$url"
		xz -cd "$cache-$v.txz" | tar -xf-
		;;
	(git://*|*.git)
		download_git
		cp -r "$cache.git" "$source.$t"
		git -C "$source.$t" checkout "$v"
		;;
	(*)
		echo error: unknown url type >&2
		exit 1
		;;
	esac

	if [ -n "$dir" -a "$dir" != "$name-$v" ]
	then mv "$dir" "$source.$t"
	fi
}

pack_configure() {
	if [ -f autogen.sh -a ! -f configure ]
	then (set -x; exec ./autogen.sh)
	fi
	if [ -f configure ]
	then (set -x; exec ./configure --prefix="$PREFIX")
	fi
}

pack_build() {
	if [ -f Makefile ]
	then (set -x; exec make)
	fi
}

pack_install() {
	(set -x; exec make PREFIX="$PREFIX" install)
}

name=$1
. "/etc/pack/$name.sh"
: ${v:=master}
: ${dir:=$name-$v}
: ${pack:=$PWD}
: ${source:=$pack/$name-$v}
: ${cache:=$pack/.cache/$name}
: ${PREFIX:=/usr/local}

t=$(date +%s)
mkdir -p .cache

case $(id -u) in
(0)
	set -x
	(cd "$source.$t" && pack_install)
	;;
(*)
	set -x
	(pack_download)
	(cd "$source.$t" && pack_configure)
	(cd "$source.$t" && pack_build)
	mv "$source.$t" "$source"
	;;
esac
