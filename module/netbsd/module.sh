repo    https://github.com/netbsd/pkgsrc /usr/pkgsrc
package mozilla-rootcerts

run && {
	mozilla-rootcerts install || :
}
