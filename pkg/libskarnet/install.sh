./configure --prefix="$PREFIX" \
  --enable-static \
  --disable-shared
gmake
gmake DESTDIR="$DESTDIR" install
