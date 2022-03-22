v=2.6.4
url=https://yices.csl.sri.com/releases/$v/yices-$v-src.tar.gz
dir=yices2-Yices-2.6.4

pack_configure() { set -eux
	export LDFLAGS='-L/usr/local/lib'

	autoconf-2.71
	./configure \
	 --prefix="$PREFIX" \
	 --with-static-gmp=/usr/local/lib/libgmp.a \
	 --with-static-gmp-include-dir=/usr/local/include
}

pack_build() { set -eux
	gmake
}

pack_install() { set -eux
	gmake install
}
