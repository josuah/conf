v=2.38
url=https://mirror.cyberbits.eu/gnu/binutils/binutils-$v.tar.gz

pack_configure() { set -eux
	exec ./configure \
	 --prefix="$PREFIX" \
	 --disable-nls
}

pack_build() { set -eux
	exec gmake
}

pack_install() {
	exec gmake PREFIX="${PREFIX}" install
}
