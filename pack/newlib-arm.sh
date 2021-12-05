ver=4.1.0
url=ftp://sourceware.org/pub/newlib/newlib-$ver.tar.gz
dir=newlib-$ver

pack_configure() {
	(set -x; exec ./configure --prefix="$prefix" --target arm-none-eabi)
}

pack_build() {
	(set -x; exec gmake)
}
