export V=master
export X=/usr/X11R6
export DIRS="-I$X/include/freetype2 -I$X/include -L$X/lib"
export CFLAGS="-Wall -Wextra -pedantic -lX11 -lXft -pthread $DIRS"

pack_download_git https://github.com/dudik/herbe
pack_make 
