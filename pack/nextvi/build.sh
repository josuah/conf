export V=master

pack_download_git https://github.com/kyx0r/nextvi
cp /etc/pack/nextvi/kmap.h /etc/pack/nextvi/conf.c .
sh build.sh
echo cp "$(readlink -f vi)" "$PREFIX/bin/neatvi"
