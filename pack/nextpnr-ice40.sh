v=master
url=https://github.com/YosysHQ/nextpnr.git

pack_configure() { set -eux
	exec cmake . \
	 -DARCH=ice40 \
	 -DEIGEN3_INCLUDE_DIRS="${PREFIX}/include/eigen3"
}

pack_build() { set -eux
	exec make VERBOSE=1
}
