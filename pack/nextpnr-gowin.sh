v=master
url=https://github.com/YosysHQ/nextpnr.git

pack_configure() { set -eux
	exec cmake . \
	 -DARCH=gowin \
	 -DEIGEN3_INCLUDE_DIRS="${PREFIX}/include/eigen3" \
	 -DCMAKE_C_COMPILER=/usr/local/bin/clang \
	 -DCMAKE_CXX_COMPILER=/usr/local/bin/clang++

#	 -DCMAKE_C_COMPILER=egcc \
#	 -DCMAKE_CXX_COMPILER=eg++

}

pack_build() { set -eux
	exec make VERBOSE=1
}
