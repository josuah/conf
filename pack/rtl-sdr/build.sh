export V=master

pack_download_git git://git.osmocom.org/rtl-sdr.git
pack_cmake \
	-DCMAKE_C_FLAGS='-L/usr/local/lib -lusb1.0 -fPIC'
ln -s librtlsdr.so.0.6git src/liblibrtlsdr.so.0.6git.so
pack_make
