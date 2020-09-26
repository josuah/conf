./configure --prefix="$PREFIX" \
  --with-include="$PREFIX/include" \
  --with-lib="$PREFIX/lib" \
  --with-lib="$PREFIX/lib/skalibs" \
  --enable-static-libc \
  --enable-static \
  --disable-shared
gmake
gmake DESTDIR="$DESTDIR" install
