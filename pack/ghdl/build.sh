export V=master
export PATH="$PWD/bin:$PATH"
export MAKE=gmake

pack_download_git https://github.com/ghdl/ghdl
mkdir -p bin
ln -sf "$(which gmake)" bin/make
pack_configure
pack_make
