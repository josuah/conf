v=master
url=git://git.osmocom.org/rtl-sdr.git

pack_configure() { set -eux
	mkdir -p build
	cd build
	cmake .. -DCMAKE_C_FLAGS='-L/usr/local/lib -lusb1.0 -fPIC'
	ln -s librtlsdr.so.0.6git src/liblibrtlsdr.so.0.6git.so
}

pack_build() { set -eux
	cd build
	make
}

pack_install() { set -eux
	cd build
	make install
}
