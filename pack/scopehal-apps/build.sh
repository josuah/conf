export V=master
export MAKE=gmake
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

pack_download_git https://github.com/glscopeclient/scopehal-apps.git
pack_download_git_submodules
pack_cmake -DPKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
pack_make
