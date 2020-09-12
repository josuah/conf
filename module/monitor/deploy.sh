
this=$PWD
tmp=$tmp/module/$name

rm -rf "/etc/module/host"
mkdir -p "$tmp/host"

for host in $(adm-db "$etc/db/host/ip" get pub=true name | sort -u); do
	(cd "$etc/db" && adm-db "$this/host.conf" template >$tmp/host/$host.conf)
done
