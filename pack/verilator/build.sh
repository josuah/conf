export V=v4.224
export MAKE=gmake
export AUTOCONF_VERSION=2.71

pack_download_git https://github.com/verilator/verilator.git
autoconf
pack_configure
pack_make
