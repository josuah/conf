echo /var/qmail >conf-qmail
env -i make NROFF=true it man
env -i make setup
mkdir -p "$DESTDIR/share"
cp -rf /var/qmail/bin "$DESTDIR"
cp -rf /var/qmail/man "$DESTDIR/share"
