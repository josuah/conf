export V=master
export MAKE=gmake

pack_download_git https://github.com/glscopeclient/scopehal-apps.git
pack_cmake
pack_make
