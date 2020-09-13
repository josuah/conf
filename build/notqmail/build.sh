v=1.08
url=https://github.com/notqmail/notqmail/releases/download/notqmail-$v/notqmail-$v.tar.gz
sha256=7b0d2153eedaa97988444334a24a0553ee25f58a6bb0521bc6d419bfa6bf7d10

build() {
	echo /var/qmail >conf-qmail

	env -i make NROFF=true it man
	env -i make setup

	mkdir -p "$DESTDIR/share"
	cp -r /var/qmail/bin "$DESTDIR"
	cp -r /var/qmail/man "$DESTDIR/share"
}
