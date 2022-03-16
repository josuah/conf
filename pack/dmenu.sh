v=master
url=git://git.suckless.org/dmenu

pack_configure() { set -eux
	sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk
	cp /etc/pack/dmenu.config.h config.h
}
