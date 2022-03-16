v=master
url=https://github.com/stolk/imcat.git

pack_configure() { set -eux
	sed -i 's,"stty size","stty -f /dev/tty size",' imcat.c
}

pack_install() { set -eux
	mkdir -p "$PREFIX/bin" "$PREFIX/man/man1"
	cp -f imcat "$PREFIX/bin/"
	cp -f imcat.1 "$PREFIX/man/man1/"
}
