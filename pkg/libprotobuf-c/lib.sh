v=1.3.3
url=https://github.com/protobuf-c/protobuf-c/releases/download/v$v/protobuf-c-$v.tar.gz
sha256=22956606ef50c60de1fabc13a78fbc50830a0447d780467d3c519f84ad527e78

build() { set -eux
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
