v=2.9.1.0
url=https://skarnet.org/software/s6/s6-$v.tar.gz
sha256=05e259532c6db8cb23f5f79938669cee30152008ac9e792ff4acb26db9a01ff7

build() { set -eux
	./configure --prefix="$PREFIX" \
	  --with-include="$PREFIX/include" \
	  --with-lib="$PREFIX/lib" \
	  --with-lib="$PREFIX/lib/skalibs" \
	  --with-lib="$PREFIX/lib/execline" \
	  --enable-static-libc \
	  --enable-static \
	  --disable-shared
	gmake
	gmake DESTDIR="$DESTDIR" install
}
