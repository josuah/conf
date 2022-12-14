#!/bin/sh
# nimble source-based package manager for custom build recipes
set -eu -o pipefail

pack_download_http() { set -eu
	mkdir -p .cache
	if [ ! -f ".cache/$NAME-$V.$1" ]; then
		curl -L -o ".cache/$NAME-$V.$1" "$2"
	fi
	if [ ! -d "$NAME-$V" ]; then
		"$3" -cd ".cache/$NAME-$V.$1" | tar -xf -
	fi
	if [ -n "$4" ]; then
		mv "$2" "$NAME-$V"
	fi
	cd "$NAME-$V"
}

pack_download_git() { set -eu
	if [ ! -d "$NAME-$V" ]; then
		git clone --depth 1 --branch "$V" "$1" "$NAME-$V"
	fi
	cd "$NAME-$V"
}

pack_rename() {
	mv "$NAME-$V" "$1"
}

pack_download_tgz() { set -eu
	pack_download_http tgz "$1" gzip "${2:-}"
}

pack_download_txz() { set -eu
	pack_download_http txz "$1" xz "${2:-}"
}

pack_download_tbz() { set -eu
	pack_download_http tbz "$1" bunzip2 "${2:-}"
}

pack_download_git_submodules() { set -eu
	git submodule update --init --recursive "$@"
}

pack_cmake() { set -eu
	mkdir -p build; cd build; cmake .. "$@"
}

pack_meson() {
	meson --prefix "$PREFIX" --libdir lib "$@" build .
	cd build
}

pack_ninja() {
	ninja "$@"
}

pack_autogen() { set -eu
	sh autogen.sh
}

pack_configure() { set -eu
	./configure --prefix="$PREFIX" "$@"
}

pack_make() { set -eu
	${MAKE:-make} PREFIX="$PREFIX" "$@"
}

pack_cp() {
	case "$1" in
	(install) shift; mkdir -p "$(dirname "$2")"; cp -f "$1" "$2" ;;
	esac
}

export NAME="$1" PREFIX="/usr/local"
shift
set -eux
. /etc/pack/$NAME/build.sh
