
cmd_repo_install() { set -eu
	send "[ -d "$path" ] || git clone --depth 1 '$url' '$path'"
}

cmd_repo_update() { set -eu
	send "	git -C '$path' remote set-url origin '$url'
		git -C '$path' fetch --all
	"
}
