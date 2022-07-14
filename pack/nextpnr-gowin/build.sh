export V=master

pack_download_git https://github.com/YosysHQ/nextpnr
pack_cmake \
	 -DARCH=gowin \
	 -DEIGEN3_INCLUDE_DIRS="${PREFIX}/include/eigen3"
pack_make VERBOSE=1
