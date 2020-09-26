
cmd_repo_install() { set -eu
	send "[ -d "$var_path" ] || git clone --depth 1 "$var_url" "$var_path"
}

cmd_repo_update() { set -eu
	send "
		git -C '$var_path' remote set-url origin '$var_url'
		git -C '$var_path' fetch --all
	"
}
