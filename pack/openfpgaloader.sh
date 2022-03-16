v=master
url=https://github.com/trabucayre/openFPGALoader.git

pack_configure() { set -eux
	mkdir -p build
	cd build
	cmake .. -DBUILD_STATIC=ON -DENABLE_CMSISDAP=OFF
}

pack_build() { set -eux
	cd build
	make
}

# [100%] Linking CXX executable openFPGALoader
# c++: warning: argument unused during compilation: '-static-libstdc++' [-Wunused-command-line-argument]
# ld: error: unable to find library -lusb-1.0
# ld: error: unable to find library -lftdi1
# ld: error: unable to find library -lusb-1.0
# ld: error: unable to find library -lftdi1
# c++: error: linker command failed with exit code 1 (use -v to see invocation)
# *** Error 1 in . (CMakeFiles/openFPGALoader.dir/build.make:753 'openFPGALoader': /usr/local/bin/cmake -E cmake_link_script CMakeFiles/openFP...)
# *** Error 2 in . (CMakeFiles/Makefile2:83 'CMakeFiles/openFPGALoader.dir/all': make -s -f CMakeFiles/openFPGALoader.dir/build.make
# CMakeFile...)
# *** Error 2 in /home/pack/openfpgaloader-master/build (Makefile:136 'all': make -s -f CMakeFiles/Makefile2 all)
