mkdir -p build
cd build
cmake -D"CMAKE_INSTALL_PREFIX"="$PREFIX" ..
make PREFIX="$PREFIX" DESTDIR="$DESTDIR" install
