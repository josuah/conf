export V=master
export MAKE=gmake
export ENABLE_TCL=0
export ENABLE_READLINE=0
export ABCURL=https://github.com/josuah/abc
export ABCREV=yosys-experimental

if command -v clang; then
	export CONFIG=clang
else
	export CONFIG=gcc
fi
pack_download_git https://github.com/josuah/yosys.git
pack_make -e
