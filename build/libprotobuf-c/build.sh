version 1.3.3
archive https://github.com/protobuf-c/protobuf-c/releases/download/v$version/protobuf-c-$version.tar.gz
checksum 22956606ef50c60de1fabc13a78fbc50830a0447d780467d3c519f84ad527e78

build() {
	./configure \
	  --prefix="$PREFIX" \
	  --enable-static=yes \
	  --enable-shared=no \
	  --disable-protoc \
	  --disable-dependency-tracking
	sed -i 's/-Wtype-limits//' Makefile
	gmake
	gmake DESTDIR="$DESTDIR" install
}
