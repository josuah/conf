export V=20220315

pack_download_tgz http://download.tuxfamily.org/gaw/download/gaw3-$V.tar.gz
pack_configure
sed -i 's/-lXext//' Makefile src/Makefile
pack_make
