v=2.6.0.0
url=http://skarnet.org/software/execline/execline-$v.tar.gz
sha256=

build() {
	./configure \
	  --prefix="$PREFIX" \
	  --with-sysdeps="$PREFIX/lib/skalibs/sysdeps" \
	  --with-include="$PREFIX/include" \
	  --with-lib="$PREFIX/lib/skalibs"
	gmake
	gmake DESTDIR="$DESTDIR" install
}
