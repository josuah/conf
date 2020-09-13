v=2.9.2.1
url=https://skarnet.org/software/skalibs/skalibs-$v.tar.gz
sha256=250b99b53dd413172db944b31c1b930aa145ac79fe6c5d7e6869ef804228c539

build() { set -eux
	./configure --prefix="$PREFIX"
	gmake
	gmake DESTDIR="$DESTDIR" install
}
