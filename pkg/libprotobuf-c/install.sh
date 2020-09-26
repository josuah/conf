./configure \
  --prefix="$PREFIX" \
  --enable-static=yes \
  --enable-shared=no \
  --disable-protoc \
  --disable-dependency-tracking
sed -i 's/-Wtype-limits//' Makefile
gmake
gmake DESTDIR="$DESTDIR" install
