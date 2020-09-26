gmake
mkdir -p "$DESTDIR$PREFIX/bin"
mkdir -p "$DESTDIR$PREFIX/lib"
mkdir -p "$DESTDIR$PREFIX/include"
cp build/brssl build/test* "$DESTDIR$PREFIX/bin"
cp build/libbearssl.a "$DESTDIR$PREFIX/lib"
cp inc/* "$DESTDIR$PREFIX/include"
