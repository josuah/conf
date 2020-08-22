version 1.3.3
archive https://github.com/protobuf-c/protobuf-c/releases/download/v$version/protobuf-c-$version.tar.gz
checksum ...

build() {
	sed -i 's/-Wtype-limits//' Makefile
	./configure \
	  --prefix="$PREFIX" \
	  --enable-static=yes \
	  --enable-shared=no \
	  --disable-protoc \
	  --disable-dependency-tracking
	gmake
	gmake DESTDIR="$DESTDIR" install
}
