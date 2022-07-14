export V=master

pack_download_git git://git.2f30.org/spoon
pack_configure
sed -i 's/.*+=.*mpd/#/' Makefile
cp /etc/pack/spoon.config.h config.h
