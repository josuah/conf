export V=1.8.3

pack_download_tgz https://www.nlnetlabs.nl/downloads/ldns/ldns-$V.tar.gz
pack_configure --with-examples
pack_make
