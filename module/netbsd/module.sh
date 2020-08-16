o package mozilla-rootcerts
o repo https://github.com/netbsd/pkgsrc /usr/pkgsrc
o exec && {
	! mozilla-rootcerts install 2>&1 | grep -v "already contains certificates"
}
