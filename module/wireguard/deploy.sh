if [ ! -f "$db/wireguard/private-key" ]; then
	(umask 600; wg genkey >$db/wireguard/private-key)
fi
