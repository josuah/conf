export V=master

pack_download_git https://github.com/YosysHQ/nextpnr.git
pack_cmake \
	 -DARCH=ice40 \
	 -DEIGEN3_INCLUDE_DIRS="${PREFIX}/include/eigen3"
pack_make VERBOSE=1
