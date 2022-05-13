v=master
url=https://github.com/anthonix/ffts.git

pack_configure() { set -eux
	mkdir -p build
	cd build
	exec cmake ..
}

pack_build() { set -eux
	cd build
	make CC=gcc
}

pack_install() { set -eux
	cd build
	make install
}
