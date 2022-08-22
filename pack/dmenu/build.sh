export V=master

pack_download_git git://git.suckless.org/dmenu
case $(uname) in (*BSD) sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk ;; esac
cp /etc/pack/dmenu/config.h config.h
pack_make
