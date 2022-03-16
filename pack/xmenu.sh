v=master
url=https://github.com/phillbush/xmenu.git

pack_configure() { set -eux
	sed -ri 's/^#(FREETYPEINC)/\1/' config.mk
}
