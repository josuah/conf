deploy_pre() { set -eu
	! mozilla-rootcerts install 2>&1 | grep -v "already contains"
}
