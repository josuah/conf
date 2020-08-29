
cmd_repo_install() {
	if [ ! -d "$var_path" ]; then
		git clone --depth 1 "$var_url" "$var_path"
	fi
}

cmd_repo_update() {
	git -C "$var_path" set-url origin "$var_url"
	git -C "$var_path" fetch --all
}
