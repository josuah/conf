url=https://github.com/lpereira/lwan
commit=a07f949141f38e46c09561b30dfb0cb31b70be35

build() { set -eux
	mkdir build
	cd build
	cmake ..
	make
}
