#!/bin/sh -eu
# nimble source-based package manager for custom build recipes

download_http() { set -eu
	if [ ! -f "$cache-$v.$1" ]; then
		curl -L -o "$cache-$v.$1" "$2"
	fi
}

download_git() { set -eu
	if [ -d "$cache.git" ]; then
		git -C ".cache/$name.git" fetch
	else
		git clone --depth 1 --branch "$v" "$url" ".cache/$name.git"
	fi
}

pack_download() { set -eu
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
		cp -r "$cache.git" "$source"
		git -C "$source" checkout "$v"
		;;
	(*)
		echo error: unknown url type >&2
		exit 1
		;;
	esac

	if [ "$dir" != "$name-$v" ]; then
		mv "$dir" "$source"
	fi
}

pack_configure() { set -eux
	if [ -f autogen.sh -a ! -f configure ]; then
		./autogen.sh
	fi
	if [ -f configure ]; then
		exec ./configure --prefix="$PREFIX"
	fi
}

pack_build() { set -eux
	exec make
}

pack_install() { set -eux
	exec make PREFIX="$PREFIX" install
}

name=$1
. "/etc/pack/$name.sh"
: ${dir:=$name-$v}
: ${pack:=$PWD}
: ${source:=$pack/$name-$v}
: ${cache:=$pack/.cache/$name}
: ${PREFIX:=/usr/local}

mkdir -p .cache

case $(id -u) in
(0)
	set -x
	cd "$source"
	(exec pack_install)
	;;
(*)
	set -x
	(exec pack_download)
	cd "$source"
	(exec pack_configure)
	(exec pack_build)
	;;
esac
