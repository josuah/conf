v=13.0.1
url=https://github.com/llvm/llvm-project/releases/download/llvmorg-$v/llvm-$v.src.tar.xz
dir=llvm-$v.src

pack_configure() { set -eux
	mkdir -p build
	cd build
	cmake -DLLVM_ENABLE_RUNTIMES=compiler-rt ..
}

pack_build() { set -eux
	cd build
	make
}
