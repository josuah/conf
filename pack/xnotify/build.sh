export V=master

pack_download_git https://github.com/phillbush/xnotify
case $(uname) in (*BSD) sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk ;; esac
cp /etc/pack/xnotify/config.h config.h
pack_make
