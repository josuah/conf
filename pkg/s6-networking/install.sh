./configure --prefix="$PREFIX" \
  --with-include="$PREFIX/include" \
  --with-lib="$PREFIX/lib" \
  --with-lib="$PREFIX/lib/skalibs" \
  --with-lib="$PREFIX/lib/execline" \
  --with-lib="$PREFIX/lib/s6" \
  --with-lib="$PREFIX/lib/s6-dns" \
  --enable-ssl=bearssl \
  --enable-static-libc \
  --enable-static \
  --disable-shared
gmake
gmake DESTDIR="$DESTDIR" install
