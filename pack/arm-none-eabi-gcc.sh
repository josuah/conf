v=11.2.0
url=http://mirror.koddos.net/gcc/releases/gcc-$v/gcc-$v.tar.gz
dir=gcc-$v

target=arm-none-eabi

pack_configure() {
	GMP=/usr/local MPFR=/usr/local MPC=/usr/local

	mkdir -p build
	cd build

	../configure --prefix="$PREFIX" --target="$target" \
	  --with-gmp="$GMP" --with-mpfr="$MPFR" --with-mpc="$MPC" \
	  --enable-languages=c
}

pack_build() {
	cd build

	gmake
}
