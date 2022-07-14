export V=master
export CFLAGS=-I/usr/local/include 

pack_download_git git://git.suckless.org/farbfeld
pack_make LDFLAGS=-L/usr/local/lib
