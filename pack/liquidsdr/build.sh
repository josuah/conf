export V=master
export MAKE=gmake
export AUTOMAKE_VERSION=1.16
export AUTOCONF_VERSION=2.71

pack_download_git https://github.com/jgaeddert/liquid-dsp.git
sh bootstrap.sh
pack_configure
pack_make
