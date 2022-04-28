v=2.15.9
url=https://github.com/gqrx-sdr/gqrx/archive/refs/tags/v$v.tar.gz

export CMAKE_PREFIX_PATH=/usr/local/lib/qt5/cmake/

pack_configure() { set -eux
	cmake . \
	-DGNURADIO_OSMOSDR_LIBRARIES=/usr/local/lib \
	-DGNURADIO_OSMOSDR_INCLUDE_DIRS=/usr/local/include/gnuradio \
	-DCMAKE_C_FLAGS='-include math.h' \
	-Wno-dev
}
