v=master
url=https://github.com/YosysHQ/SymbiYosys.git

pack_build() { set -eux
}

pack_install() { set -eux
	gmake install
}
