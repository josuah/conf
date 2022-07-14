export V=master
export AUTOCONF_VERSION=2.71
export AUTOMAKE_VERSION=1.16

pack_download_git https://github.com/sm00th/bitlbee-discord
sed -i '/AC_DISABLE_STATIC/ d' configure.ac
sh autogen.sh
pack_configure
pack_make
