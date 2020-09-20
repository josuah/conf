
deploy_pre() { set -eu
	cp -rjfhome/.* "$HOME"
	mkdir -p "$HOME/.ssh/sock"
	touch "$HOME/.ssh/config_local"
}
