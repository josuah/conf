
deploy_pre() { set -eu
	cp -rf home/.* "$HOME"
	mkdir -p "$HOME/.ssh/sock"
	touch "$HOME/.ssh/config_local"
}
