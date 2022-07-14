export V=13.0.1

pack_download_git https://github.com/llvm/llvm-project/releases/download/llvmorg-$V/llvm-$V.src.tar.xz llvm-$V.src
pack_cmake -DLLVM_ENABLE_RUNTIMES=compiler-rt
pack_make
