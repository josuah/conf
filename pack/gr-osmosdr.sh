v=gr3.8
url=git://git.osmocom.org/gr-osmosdr

pack_configure() { set -eux
	mkdir -p build
	cd build
	cmake ..
}

pack_build() { set -eux
	cd build
	make
}

pack_install() { set -eux
	cd build
	make install
}
