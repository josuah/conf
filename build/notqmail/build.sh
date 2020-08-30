set -x

v=1.08
url=https://github.com/notqmail/notqmail/releases/download/notqmail-$v/notqmail-$v.tar.gz
sha256=7b0d2153eedaa97988444334a24a0553ee25f58a6bb0521bc6d419bfa6bf7d10

build() {
	echo "$DESTDIR/$PREFIX" >conf-qmail
	make NROFF=true it man
	DESTDIR= make setup
	if [ ! -d /var/spool/qmail ]; then
		mv "$DESTDIR$PREFIX/queue" /var/spool/qmail
	fi
	rm -rf "$DESTDIR$PREFIX/queue" "$DESTDIR$PREFIX/control"
	rm -rf  "$DESTDIR$PREFIX/alias" "$DESTDIR$PREFIX/users"
	mkdir -p /etc/spool/qmail /etc/qmail/control /etc/qmail/alias
	mkdir -p /etc/qmail/users
	ln -sf /var/spool/qmail /etc/qmail/control "$DESTDIR$PREFIX"
	ln -sf  /etc/qmail/alias /etc/qmail/users "$DESTDIR$PREFIX"
	mv "$DESTDIR$PREFIX/qmail" "$DESTDIR$PREFIX/queue"
}
