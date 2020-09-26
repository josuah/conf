v=2.6.1.0
url=https://skarnet.org/software/execline/execline-$v.tar.gz
sha256=a24c76f097ff44fe50b63b89bcde5d6ba9a481aecddbe88ee01b0e5a7b314556

build() { set -eux
	./configure --prefix="$PREFIX" \
	  --with-include="$PREFIX/include" \
	  --with-lib="$PREFIX/lib" \
	  --with-lib="$PREFIX/lib/skalibs" \
	  --enable-static-libc \
	  --enable-static \
	  --disable-shared
	gmake
	gmake DESTDIR="$DESTDIR" install
}
