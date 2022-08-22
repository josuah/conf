export V=master

pack_download_git git://git.suckless.org/st
case $(uname) in (*BSD) sed -ri 's/^#(FREETYPEINC *=)/\1/' config.mk ;; esac
sed -ri 's/ -lrt / /' config.mk
cp /etc/pack/st/config.h config.h
pack_make
