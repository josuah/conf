v=master
url=https://github.com/phillbush/xnotify.git

pack_configure() { set -eux
	sed -ri 's/^#(FREETYPEINC)/\1/' config.mk
	cp /etc/pack/xnotify.config.h config.h
}
