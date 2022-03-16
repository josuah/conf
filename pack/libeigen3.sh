v=master
url=https://gitlab.com/libeigen/eigen.git

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
