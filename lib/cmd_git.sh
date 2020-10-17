
cmd_git_install() { set -eu
	send "[ -d "$path" ] || git clone --depth 1 '$name' '$path'"
}

cmd_git_update() { set -eu
	send "	git -C '$path' remote set-url origin '$name'
		git -C '$path' fetch --all
	"
}
