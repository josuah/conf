export V=2.38
export MAKE=gmake

pack_download_tgz https://mirror.cyberbits.eu/gnu/binutils/binutils-$V.tar.gz
pack_configure --disable-nls
pack_make
