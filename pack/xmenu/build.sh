export V=master

pack_download_git https://github.com/phillbush/xmenu
sed -ri 's/^#(FREETYPEINC)/\1/' config.mk
pack_make
