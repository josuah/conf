export V=11.2.0
export GMP=/usr/local
export MPFR=/usr/local
export MPC=/usr/local

pack_download_tgz http://mirror.koddos.net/gcc/releases/gcc-$V/gcc-$V.tar.gz gcc-$V
mkdir -p build
cd build
pack_configure --target=arm-none-eabi \
	--with-gmp="$GMP" --with-mpfr="$MPFR" --with-mpc="$MPC" \
	--enable-languages=c --disable-libssp
pack_make
