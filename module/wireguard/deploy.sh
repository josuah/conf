cd "$current"

if [ -z "$(bin/adm-db db/wireguard/key get privkey)" ]; then
	bin/adm-db db/wireguard/key add privkey="$(wg genkey)"
fi
