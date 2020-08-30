v=1.08
url=https://github.com/notqmail/notqmail/releases/download/notqmail-$v/notqmail-$v.tar.gz
sha256=7b0d2153eedaa97988444334a24a0553ee25f58a6bb0521bc6d419bfa6bf7d10

build() {
	make NROFF=true it man
	DESTDIR= make setup

	mkdir -p "$DESTDIR$PREFIX"
	cp -r /var/qmail/bin "$DESTDIR$PREFIX"
	rm -rf /var/qmail/bin
	ln -sf "$PREFIX/bin" /var/qmail
}
