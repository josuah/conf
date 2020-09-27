
deploy_pre() { set -eu
	type -v 9 >/dev/null && exit 0
	cd /usr/plan9
	./INSTALL
}
