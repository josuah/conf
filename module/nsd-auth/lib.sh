
deploy_pre() { set -eu

	mkdir -p "$dest/var/nsd/zones/master"

	for soa in $(adm-db "$db"/dns_zones get soa); do
		(cd "$db" && zone=$soa adm-db "$conf/zone" template >$dest/var/nsd/zones/master/$soa)
	done

	nsd-control-setup
}
