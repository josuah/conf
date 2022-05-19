v=3.3.111
url=http://gtkwave.sourceforge.net/gtkwave-gtk3-$v.tar.gz

pack_configure() { set -eux
	sed -i 's/\${TCL_VERSION}/86/' configure # dayum!

	./configure --prefix="$PREFIX" \
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
}
