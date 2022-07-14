export V=master

pack_download_git https://github.com/josuah/abc
pack_make
mkdir -p "$PREFIX/bin"
cp abc "$PREFIX/bin/yosys-abc"
