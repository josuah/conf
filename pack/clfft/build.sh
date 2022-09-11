export V=master

pack_download_git https://github.com/clMathLibraries/clFFT
cd src
pack_cmake
pack_make
