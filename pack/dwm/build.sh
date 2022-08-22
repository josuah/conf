export V=master

pack_download_git git://git.suckless.org/dwm
case $(uname) in (*BSD) sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk ;; esac
cp /etc/pack/dwm/config.h config.h
pack_make
