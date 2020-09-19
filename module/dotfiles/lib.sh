
deploy_pre() { set -eu

	find * -name "lib.sh" -o \
		-type d -exec mkdir -p "$HOME/.{}" \; -o \
		-type f -exec cp "$PWD/{}" "$HOME/.{}" \;

	mkdir -p "$HOME/.ssh/sock"
	touch "$HOME/.ssh/config_local"
}
