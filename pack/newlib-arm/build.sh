export v=4.1.0
export MAKE=gmake

pack_download ftp://sourceware.org/pub/newlib/newlib-$V.tar.gz newlib-$V
pack_configure --target arm-none-eabi
pack_make
