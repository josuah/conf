v=4.1.0
url=ftp://sourceware.org/pub/newlib/newlib-$v.tar.gz
dir=newlib-$v

pack_configure() {
	(set -x; exec ./configure --prefix="$prefix" --target arm-none-eabi)
}

pack_build() {
	(set -x; exec gmake)
}
