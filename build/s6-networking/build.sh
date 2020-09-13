v=2.3.1.2
url=http://skarnet.org/software/s6-networking/s6-networking-$v.tar.gz
sha256=

build() {
	./configure --prefix="$PREFIX" \
	  --enable-static-libc \
	  --enable-ssl=bearssl
	gmake
	gmake DESTDIR="$DESTDIR" install
}
