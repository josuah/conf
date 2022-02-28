v=13.0.1
url=https://github.com/llvm/llvm-project/releases/download/llvmorg-$v/compiler-rt-$v.src.tar.xz
dir=compiler-rt-$v.src

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
	make PREFIX="$PREFIX" install
}
