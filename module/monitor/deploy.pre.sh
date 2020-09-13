rm -rf "/etc/module/host"
mkdir -p "$o/host"

for host in $(adm-db "$etc/db/host/ip" get pub=true host | sort -u); do
	(cd "$etc/db" && adm-db "$i/host.conf" template >$o/host/$host.conf)
done
