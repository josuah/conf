v=2.9.2.1
url=https://skarnet.org/software/skalibs/skalibs-$v.tar.gz
sha256=

build() {
	./configure --prefix="$PREFIX"
	gmake
	gmake DESTDIR="$DESTDIR" install
}
