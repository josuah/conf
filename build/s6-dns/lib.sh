v=2.3.2.0
url=http://www.skarnet.org/software/s6-dns/s6-dns-$v.tar.gz
sha256=27b6129eaaea31ab907eea8a52369fe864ba7984c8f3e33dc098beb47b581e26

build() { set -eux
	./configure --prefix="$PREFIX" \
	  --with-include="$PREFIX/include" \
	  --with-lib="$PREFIX/lib" \
	  --with-lib="$PREFIX/lib/skalibs" \
	  --with-lib="$PREFIX/lib/execline" \
	  --with-lib="$PREFIX/lib/s6" \
	  --enable-static-libc \
	  --enable-static \
	  --disable-shared
	gmake
	gmake DESTDIR="$DESTDIR" install
}
