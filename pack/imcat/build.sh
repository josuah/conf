export V=master

pack_download_git https://github.com/stolk/imcat.git
sed -i 's,"stty size","stty -f /dev/tty size",' imcat.c
pack_make
mkdir -p "$PREFIX/bin" "$PREFIX/man/man1"
cp -f imcat "$PREFIX/bin/"
cp -f imcat.1 "$PREFIX/man/man1/"
