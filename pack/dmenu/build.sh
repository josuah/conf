export V=master

pack_download_git git://git.suckless.org/dmenu
sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk
cp /etc/pack/dmenu/config.h config.h
pack_make
