#!/bin/sh -eu
# nimble source-based package manager for custom build recipes

download_http() {
	if [ ! -f "$cache-$ver.tz" ]
	then curl -L -o "$cache-$ver.tz" "$1"
	fi
}

download_git() {
	if [ ! -d "$cache.git" ]
	then git clone --depth 1 --branch "$ver" "$url" ".cache/$pack.git"
	else git -C ".cache/$pack.git" fetch
	fi
}

pack_download() {
	case $url in
	(*.tgz|*.tar.gz)
		download_http "$url"
		gzip -cd "$cache-$ver.tz" | tar -xf-
		;;
	(*.txz|*.tar.xz)
		download_http "$url"
		xz -cd "$cache-$ver.tz" | tar -xf-
		;;
	(git://*|*.git)
		download_git
		cp -r "$cache.git" "$source"
		git -C "$source" checkout "$ver"
		;;
	(*)
		echo error: unknown url type >&2
		exit 1
		;;
	esac

	if [ -n "$dir" -a "$dir" != "$pack-$ver" ]; then
		mv "$dir" "$source"
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

pack=$1
. "/etc/pack/$pack.sh"
: ${ver:=master}
: ${dir:=$pack-$ver}
: ${source:=$PWD/$pack-$ver}
: ${cache:=$PWD/.cache/$pack}
: ${PREFIX:=/usr/local}

case $(id -u) in
(0)
	(set +u; cd "$source" && pack_install)
	;;
(*)
	mkdir -p .cache
	trap 'rm -rf "$source"' INT TERM EXIT HUP
	([ ! -d "$source" ] && pack_download)
	(set +u; cd "$source" && pack_configure)
	(set +u; cd "$source" && pack_build)
	exec echo "built $pack in $source, run same command as root to install"
	;;
esac
