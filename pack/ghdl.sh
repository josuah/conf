url=https://github.com/ghdl/ghdl.git
v=master

export CC=cc

pack_configure() { set -eux
	export PATH="$PWD/bin:$PATH"

	mkdir -p bin
	ln -sf "$(which gmake)" bin/make
	./configure --prefix="$PREFIX"
}

pack_build() { set -eux
	gmake
}

pack_install() { set -eux
	gmake install
}
