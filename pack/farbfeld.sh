v=master
url=git://git.suckless.org/farbfeld

pack_build() { set -eux
	make CFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib
}
