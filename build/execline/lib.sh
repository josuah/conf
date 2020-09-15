v=2.6.0.0
url=http://skarnet.org/software/execline/execline-$v.tar.gz
sha256=5415f5b98c8e3edb8e94fa9c9d42de1cdb86a8977e9b4212c9122bdcb9dad7d4

build() { set -eux
	./configure \
	  --prefix="$PREFIX" \
	  --with-sysdeps="$PREFIX/lib/skalibs/sysdeps" \
	  --with-include="$PREFIX/include" \
	  --with-lib="$PREFIX/lib/skalibs"
	gmake
	gmake DESTDIR="$DESTDIR" install
}
