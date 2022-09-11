export V=master
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

pack_download_git https://github.com/rubund/graywolf
pack_cmake
pack_make
