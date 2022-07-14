export v=master
export MAKE=gmake

pack_download_git https://github.com/josuah/yosys.git
pack_make \
	CONFIG=clang \
	ENABLE_TCL=0 \
	ENABLE_READLINE=0 \
	ABCURL=https://github.com/josuah/abc \
	ABCREV=yosys-experimental
