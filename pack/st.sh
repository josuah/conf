v=master
url=git://git.suckless.org/st

pack_configure() { set -eux
	sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk
	sed -ri 's/ -lrt / /' config.mk
	cp /etc/pack/st.config.h config.h
}
