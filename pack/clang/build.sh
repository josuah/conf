export V=13.0.1
export LLVM_DIR="$pack/llvm-$v/cmake"

pack_download_txz https://github.com/llvm/llvm-project/releases/download/llvmorg-$V/clang-$V.src.tar.xz $NAME-$V.src
pack_cmake
pack_make
