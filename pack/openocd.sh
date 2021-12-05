ver=rp2040
url=https://github.com/raspberrypi/openocd.git

pack_configure() {
	export AUTOMAKE_VERSION=1.16 AUTOCONF_VERSION=2.69
	./bootstrap
	exec ./configure --prefix="$prefix" \
		--enable-picoprobe \
		--disable-werror \
		--without-capstone \
		LIBFTDI_CFLAGS="$(pkg-config --cflags libftdi1)" \
		LIBFTDI_LDFLAGS="$(pkg-config --libs libftdi1)" \
		LIBUSB0_CFLAGS="$(pkg-config --cflags libusb)" \
		LIBUSB0_LDFLAGS="$(pkg-config --libs libusb)" \
		LIBUSB1_CFLAGS="$(pkg-config --cflags libusb)" \
		LIBUSB1_LDFLAGS="$(pkg-config --libs libusb)" \
		HIDAPI_CLFAGS="$(pkg-config --libs hidapi-libusb)" \
		HIDAPI_LDLFAGS="$(pkg-config --libs hidapi-libusb)"
}

pack_build() {
	export PATH="$PWD:$PATH"
	touch makeinfo
	chmod +x makeinfo
	sed -i 's/hid_init/hidapi_&/' src/jtag/drivers/*.c
	exec gmake
}

pack_install() {
	export PATH="$PWD:$PATH"
	exec gmake install
}
