mkdir -p "$dest/var/nsd/zones/master"

for soa in $(adm-db "$etc/db/dns/zones" get soa); do
	(cd "$etc/db" && zone=$soa adm-db "$conf/zone" template >$dest/var/nsd/zones/master/$soa)
done

nsd-control-setup
