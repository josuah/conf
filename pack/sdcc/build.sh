export V=4.2.0

pack_download_tbz https://sourceforge.net/projects/sdcc/files/sdcc/4.2.0/sdcc-src-4.2.0.tar.bz2
pack_configure --disable-ucsim
pack_make
