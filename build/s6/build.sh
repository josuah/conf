v=2.9.1.0
url=https://skarnet.org/software/s6/s6-$v.tar.gz
sha256=

build() {
	./configure --prefix="$PREFIX" \
	  --enable-static-libc
	gmake
	gmake DESTDIR="$DESTDIR" install
}
