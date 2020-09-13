
deploy_pre() { set -eu
	local out="$dest/etc/monitor/host"

	rm -rf "/etc/module/host"
	mkdir -p "$dest/etc/monitor/host"

	for host in $(adm-db "$etc/db/host/ip" get pub=true host | sort -u); do
		(cd "$etc/db" && adm-db "$conf/host.conf" template >$out/$host.conf)
	done
}
