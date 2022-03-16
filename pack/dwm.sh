v=master
url=git://git.suckless.org/dwm

pack_configure() { set -eux
	sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk
	cp /etc/pack/dwm.config.h config.h
}
