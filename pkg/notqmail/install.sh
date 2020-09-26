echo /var/qmail >conf-qmail
env -i make NROFF=true it man
env -i make setup
mkdir -p "$DESTDIR/share"
cp -r /var/qmail/bin "$DESTDIR"
cp -r /var/qmail/man "$DESTDIR/share"
