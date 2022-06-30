v=master
url=https://github.com/glscopeclient/scopehal-apps.git

pack_configure() { set -eux
	mkdir -p build
	cd build
	exec cmake ..
}

pack_build() {
	cd build
	exec gmake
}

pack_install() {
	cd build
	exec gmake install
}
