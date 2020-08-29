v=0.5
url=https://github.com/jedisct1/encpipe/archive/$v.tar.gz
sha256=01fff57f2231667b3c05ff865f872e1aa8f5e4455730972fb42d36ac8f6a96ba

build() {
	make
	make PREFIX="$DESTDIR$PREFIX" install
}
