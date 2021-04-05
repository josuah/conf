url=git://git.suckless.org/dwm
ver=master

pack_configure() {
	sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk
	sed 's/Mod1Mask/Mod4Mask/' config.def.h >config.h
}
