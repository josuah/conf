v=master
url=https://github.com/aligrudi/neatvi.git

pack_install() { set -eux
	cp vi "$PREFIX/bin/neatvi"
}
