export V=3.3.111

pack_download_tgz http://gtkwave.sourceforge.net/gtkwave-gtk3-$v.tar.gz
sed -i 's/\${TCL_VERSION}/86/' configure # dayum!
pack_configure \
	  --with-tcl=/usr/local/lib/tcl/tcl8.6/ \
	  --with-tk=/usr/local/lib/tcl/tk8.6/ \
	  --enable-gtk3 \
	  --enable-tcl \
	  --disable-xz \
	  CFLAGS="-I/usr/local/include" \
	  LDFLAGS="-L/usr/local/lib"
find . -name '*.[ch]' -exec sed -i '
	/#include .*wayland.*/ d
	s;readlink(".*", \(.*\), \(.*\));strlcpy(\1, "/usr/local/bin/gtkwave", \2);
' {} +
pack_make
