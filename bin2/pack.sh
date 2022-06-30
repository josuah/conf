#!/bin/sh -eu
# nimble source-based package manager for custom build recipes

download_http() { set -eu
	if [ ! -f "$cache-$v.$1" ]; then
		curl -L -o "$cache-$v.$1" "$2"
	fi
	"$3" -cd "$cache-$v.$1" | tar -xf -
}

download_git() { set -eu
	if [ -d "$cache.git" ]; then
		git -C "$cache.git" fetch origin "$v"
	else
		git clone --bare --depth 1 --branch "$v" "$url" "$cache.git"
	fi
	git clone "$cache.git" "${source}"
}

pack_download() { set -eu
	if [ -d "$dir" ]; then
		return
	fi

	case $url in
	(*.tgz|*.tar.gz)
		download_http tgz "$url" gzip
		;;
	(*.txz|*.tar.xz)
		download_http txz "$url" xz
		;;
	(git://*|*.git)
		download_git
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
	cd "$source"
	(exec pack_install)
	;;
(*)
	([ -d "$source" ] || exec pack_download)
	cd "$source"
	(exec pack_configure)
	(exec pack_build)
	;;
esac
