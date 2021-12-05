url=https://github.com/phillbush/xmenu.git
ver=master

pack_configure() {
	sed -ri 's/^#(FREETYPEINC)/\1/' config.mk
}
