v=master
url=https://github.com/jgaeddert/liquid-dsp.git

export AUTOMAKE_VERSION=1.16
export AUTOCONF_VERSION=2.71

pack_configure() { set -eux
	sh bootstrap.sh
	./configure --prefix="$PREFIX"
}

pack_build() { set -eux
	gmake
}

pack_install() { set -eux
	gmake install
}
