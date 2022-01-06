ver=master
url=https://github.com/dudik/herbe.git

pack_build() {
	set -x
	X=/usr/X11R6
	DIRS="-I$X/include/freetype2 -I$X/include -L$X/lib"
	make CFLAGS="-Wall -Wextra -pedantic -lX11 -lXft -pthread $DIRS"
}
