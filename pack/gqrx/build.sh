export V=2.15.9
export CMAKE_PREFIX_PATH=/usr/local/lib/qt5/cmake/

pack_download_tgz https://github.com/gqrx-sdr/gqrx/archive/refs/tags/v$v.tar.gz
pack_cmake \
	-DGNURADIO_OSMOSDR_LIBRARIES=/usr/local/lib \
	-DGNURADIO_OSMOSDR_INCLUDE_DIRS=/usr/local/include/gnuradio \
	-DCMAKE_C_FLAGS='-D__GNUC__=11' \
	-Wno-dev
pack_make
