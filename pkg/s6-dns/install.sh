./configure --prefix="$PREFIX" \
  --with-include="$PREFIX/include" \
  --with-lib="$PREFIX/lib" \
  --with-lib="$PREFIX/lib/skalibs" \
  --with-lib="$PREFIX/lib/execline" \
  --with-lib="$PREFIX/lib/s6" \
  --enable-static-libc \
  --enable-static \
  --disable-shared
gmake
gmake DESTDIR="$DESTDIR" install
