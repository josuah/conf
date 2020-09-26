./configure \
  --prefix="$PREFIX" \
  --enable-static=yes \
  --enable-shared=no \
  --disable-cxx
make
make DESTDIR="$DESTDIR" install
