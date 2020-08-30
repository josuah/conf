v=1.08
url=https://github.com/notqmail/notqmail/releases/download/notqmail-$v/notqmail-$v.tar.gz
sha256=7b0d2153eedaa97988444334a24a0553ee25f58a6bb0521bc6d419bfa6bf7d10

_build_symlink() {
	mkdir -p "$1"
	ln -s "$1" "$tmp/$(basename "$2")"
	mkdir -p "$(dirname "$2")"
	mv "$tmp/$(basename "$2")" "$(dirname "$2")"
}

build() {
	make NROFF=true it man

	_build_symlink	/etc/qmail/control	/var/qmail/control
	_build_symlink	/etc/qmail/alias	/var/qmail/alias
	_build_symlink	/etc/qmail/users	/var/qmail/users
	_build_symlink	/var/spool/qmail	/var/qmail/queue
	_build_symlink	"$PREFIX$DESTDIR/bin"	/var/qmail/bin
	_build_symlink	"$PREFIX$DESTDIR/man"	/var/qmail/man

	make setup

	rm -f /var/qmail/bin /var/qmail/man
	_build_symlink	"$PREFIX/bin"		/var/qmail/bin
	_build_symlink	"$PREFIX/share/man"	/var/qmail/man
}
