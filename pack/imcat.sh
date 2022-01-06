v=master
url=https://github.com/stolk/imcat.git

pack_configure() {
	sed -i 's,"stty size","stty -f /dev/tty size",' imcat.c
}

pack_install() {
	mkdir -p "$PREFIX/bin" "$PREFIX/man/man1"
	cp -f imcat "$PREFIX/bin/"
	cp -f imcat.1 "$PREFIX/man/man1/"
}
