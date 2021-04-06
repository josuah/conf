#url=https://xenbits.xen.org/git-http/xen.git
ver=4.14.1
url=https://downloads.xenproject.org/release/xen/$ver/xen-$ver.tar.gz

pack_configure() {
	: everything happen in the makefile
}

pack_build() {
	gmake
}
