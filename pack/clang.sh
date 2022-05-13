v=13.0.1
url=https://github.com/llvm/llvm-project/releases/download/llvmorg-$v/clang-$v.src.tar.xz
dir=clang-$v.src

export LLVM_DIR="$pack/llvm-$v/cmake"

pack_configure() { set -eux
	mkdir -p build
	cd build
	cmake  ..
}

pack_build() { set -eux
	cd build
	make
}
