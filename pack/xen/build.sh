export V=4.14.1

pack_download_tgz https://downloads.xenproject.org/release/xen/$V/xen-$V.tar.gz
pack_configure
pack_make
