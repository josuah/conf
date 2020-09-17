
deploy_pre() { set -eu
	local out="$dest/etc/monitor/host"

	mkdir -p "$dest/etc/monitower/queue.table"

	for host in $(adm-db "$etc/db/host/ip" get pub=true host | sort -u); do
		for ip in $(adm-db "$etc/db/host/ip" get ip pub=true host="$host"); do
			adm list node/$host | while IFS=' /' read type name vars; do
				[ "$type" = "monitor" ] || continue
				echo "host=$host ip=$ip check=$name $vars"
			done
		done
	done >$dest/etc/monitower/queue
}
