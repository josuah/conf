export V=master

pack_download_git git://git.suckless.org/dwm
sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk
cp /etc/pack/dwm/config.h config.h
pack_make
