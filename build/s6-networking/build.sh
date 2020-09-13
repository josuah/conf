v=2.3.1.2
url=http://skarnet.org/software/s6-networking/s6-networking-$v.tar.gz
sha256=d953dbfdf9020bb27e873328df1b644f8a7b6a3972a4288b1f20edeaf85b4980

build() {
	set -eu
	./configure --prefix="$PREFIX" \
	  --enable-static-libc \
	  --enable-ssl=bearssl
	gmake
	gmake DESTDIR="$DESTDIR" install
}
