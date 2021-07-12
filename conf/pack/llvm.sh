ver=12.0.1
url=https://github.com/llvm/llvm-project/releases/download/llvmorg-$ver/llvm-$ver.src.tar.xz

export LDFLAGS=-L/usr/local/lib
export CFLAGS=-I/usr/local/include
export CXXFLAGS=-I/usr/local/include

pack_configure() {
	mkdir -p build
	cd build
	cmake ..
}

pack_build() {
	cd build
	make
}
