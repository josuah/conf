o exec && {
	path=$db/wireguard/pass
	[ ! -f "$path" ] || (
		mkdir -p "$(dirname "$path")"
		umask 600
		wg genkey >$path
	)
}
o conf conf.ini
