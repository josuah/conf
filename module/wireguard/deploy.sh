
deploy_pre() { set -eu

	cd "$etc"

	mkdir -p db/local/wireguard
	if [ -z "$(bin/adm-db local/wireguard/pass get privkey)" ]; then
		bin/adm-db local/wireguard/pass add privkey="$(wg genkey)"
	fi
}
