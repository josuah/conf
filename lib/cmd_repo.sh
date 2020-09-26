
cmd_repo_install() { set -eu
	if [ ! -d "$var_path" ]; then
		git clone --depth 1 "$var_url" "$var_path"
	fi
}

cmd_repo_update() { set -eu
	git -C "$var_path" remote set-url origin "$var_url"
	git -C "$var_path" fetch --all
}
