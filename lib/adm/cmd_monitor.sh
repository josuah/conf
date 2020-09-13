
cmd_monitor_monitor() { set -eu
	local name="$1" ip
	shift

	for ip in $(adm-db "$etc/db/host/ip" get ip host="$host" pub=true); do
		echo "name=$name" ip="$ip" "$@"
	done
}
