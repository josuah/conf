#!/bin/sh -eu
# nimble source-based package manager for custom build recipes

pack_download() {
	case $url in
	(*.txg|*.tar.gz)
		curl -L "$url" | gzip -cd | tar -xf-
		;;
	(*.txz|*.tar.xz)
		curl -L "$url" | xz -cd | tar -xf-
		;;
	(git://*|*.git)
		git clone --depth 1 --branch "$ver" "$url" "$SOURCE"
		rm -rf "$SOURCE/.git"
		;;
	(*)
		echo error: unknown url type >&2
		exit 1
		;;
	esac
}

pack_configure() {
	if [ -f autogen.sh -a ! -f configure ]; then
		./autogen.sh
	fi
	if [ -f configure ]; then
		./configure --prefix="$PREFIX"
	fi
}

pack_build() {
	if [ -f Makefile ]; then
		make
	fi
}

pack_install() {
	make PREFIX="$PREFIX" install
}

pack=$1

. "/etc/pack/$pack.sh"

export SOURCE="$PWD/$pack-$ver"
trap 'rm -rf "$SOURCE"' INT TERM EXIT HUP

if [ ! -d "$SOURCE" ]; then
	mkdir -p -m 755 source
	(cd source && pack_download)
fi

export PREFIX="$PWD/build/$pack-$ver"
trap 'rm -rf "$PREFIX"' INT TERM EXIT HUP

if [ ! -d "$PREFIX" ]; then
	mkdir -p -m 755  "$PREFIX"
	(set +u; cd "$SOURCE" && pack_configure)
	(set +u; cd "$SOURCE" && pack_build)
	(set +u; cd "$SOURCE" && pack_install)
fi

exec echo "built $pack in $PREFIX"
