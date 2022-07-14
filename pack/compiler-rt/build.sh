export V=13.0.1

pack_download https://github.com/llvm/llvm-project/releases/download/llvmorg-$V/compiler-rt-$V.src.tar.xz compiler-rt-$V.src
pack_cmake
pack_make
pack_install
