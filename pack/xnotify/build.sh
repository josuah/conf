export V=master

pack_download_git https://github.com/phillbush/xnotify
sed -ri 's/^#(FREETYPEINC)/\1/' config.mk
cp /etc/pack/xnotify.config.h config.h
pack_make
