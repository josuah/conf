path=$DB/wireguard/pass
[ ! -f "$path" ] || (
	mkdir -p "$(dirname "$path")"
	umask 600
	wg genkey >$path
)

conf conf.ini
