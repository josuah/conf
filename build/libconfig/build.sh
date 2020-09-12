v=1.4.10
url=http://www.hyperrealm.com/packages/libconfig-$v.tar.gz
sha256=c04cc443fb02a548502d737fb7d9593e9bc3a6e41fac696dfe65d66ca4f9d0e1

build() {
	./configure \
	  --prefix="$PREFIX" \
	  --enable-static=yes \
	  --enable-shared=no \
	  --disable-cxx
	make
	make DESTDIR="$DESTDIR" install
}
