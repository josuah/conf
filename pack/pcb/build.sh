export V=master

pack_download_git git://opencircuitdesign.com/pcb
pack_configure
sed -i '/@setcontentsaftertitlepage/ d; s/@itemx/@item/' doc/pcb.texi
pack_make
