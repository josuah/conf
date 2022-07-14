export V=2.6.4
export LDFLAGS='-L/usr/local/lib'
export MAKE=gmake

pack_download_git https://yices.csl.sri.com/releases/$V/yices-$V-src.tar.gz yices2-Yices-2.6.4
autoconf-2.71
pack_configure \
	 --with-static-gmp=/usr/local/lib/libgmp.a \
	 --with-static-gmp-include-dir=/usr/local/include
pack_make
