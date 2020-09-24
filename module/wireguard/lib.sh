
deploy_pre() { set -eu

	cd "$etc"

	mkdir -p db/local/wireguard
	if [ -z "$(bin/adm-db "$db"/wireguard_var get pass)" ]; then
		bin/adm-db "$db"/wireguard_var add privkey="$(wg genkey)"
	fi
}
