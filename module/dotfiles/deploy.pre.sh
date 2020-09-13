find * -name "deploy*sh" -o \
	-type d -exec mkdir -p "$HOME/.{}" \; -o \
	-type f -exec ln -sf "$PWD/{}" "$HOME/.{}" \;

mkdir -p "$HOME/.ssh/sock"
touch "$HOME/.ssh/config.local"
