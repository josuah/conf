v=master
url=git://git.2f30.org/spoon

pack_configure() { set -eux
	./configure --prefix="$PREFIX"
	sed -i 's/.*+=.*mpd/#/' Makefile
	cp /etc/pack/spoon.config.h config.h
}
