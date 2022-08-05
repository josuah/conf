#export V=v4.224 # latest stable
#export V=v4.106 # latest expected to be working with cocotb
export V=master # development version
export MAKE=gmake
export AUTOCONF_VERSION=2.71

pack_download_git https://github.com/verilator/verilator.git
autoconf
pack_configure
pack_make
