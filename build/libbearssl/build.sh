v=0.4
url=https://bearssl.org/bearssl-$v.tar.gz
sha256=674d69ca6811a4a091de96d5866e22f06ffbf8d3765f0e884d9daeb80aa904d4

build() { set -eux
	gmake
	mkdir -p "$DESTDIR$PREFIX/bin"
	mkdir -p "$DESTDIR$PREFIX/lib"
	mkdir -p "$DESTDIR$PREFIX/include"
	cp build/brssl build/test* "$DESTDIR$PREFIX/bin"
	cp build/libbearssl.a "$DESTDIR$PREFIX/lib"
	cp inc/* "$DESTDIR$PREFIX/include"
}
