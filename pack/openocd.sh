v=master
url=https://git.code.sf.net/p/openocd/code.git

export AUTOMAKE_VERSION=1.16
export AUTOCONF_VERSION=2.69
export PATH="$PWD:$PATH"

pack_configure() { set -eux
	./bootstrap
	exec ./configure --prefix="$PREFIX" \
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

pack_build() { set -eux
	touch makeinfo
	chmod +x makeinfo
	sed -i 's/hid_init/hidapi_&/' src/jtag/drivers/*.c
	exec gmake
}

pack_install() { set -eux
	exec gmake install
}
