v=master
url=https://github.com/YosysHQ/icestorm.git

pack_build() { set -eux
	exec gmake CXX="c++"
}

pack_install() { set -eux
	exec gmake PREFTIX="$PREFIX" install
}
