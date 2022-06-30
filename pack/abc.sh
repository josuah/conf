url=https://github.com/YosysHQ/abc.git
v=master
export CFLAGS="-DRLIMIT_AS=9 -DLIN64"

pack_configure() { set -eux
}

pack_build() { set -eux
	gmake CC="cc $CFLAGS" CXX="c++ $CFLAGS" LIBS="-lpthread -fPIC -lstdc++ -lreadline"
}

pack_install() { set -eux
	mkdir -p "$PREFIX/bin"
	cp abc "$PREFIX/bin/yosys-abc"
}
