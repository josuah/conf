v=2.3.1.2
url=http://skarnet.org/software/s6-networking/s6-networking-$v.tar.gz
sha256=d953dbfdf9020bb27e873328df1b644f8a7b6a3972a4288b1f20edeaf85b4980

build() { set -eux
	./configure --prefix="$PREFIX" \
	  --with-include="$PREFIX/include" \
	  --with-lib="$PREFIX/lib" \
	  --with-lib="$PREFIX/lib/skalibs" \
	  --with-lib="$PREFIX/lib/execline" \
	  --with-lib="$PREFIX/lib/s6" \
	  --with-lib="$PREFIX/lib/s6-dns" \
	  --enable-ssl=bearssl \
	  --enable-static-libc \
	  --enable-static \
	  --disable-shared
	gmake
	gmake DESTDIR="$DESTDIR" install
}
