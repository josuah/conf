
_monitower_dns() {
	adm-db "$etc/db/dns/zones" get soa \
	| sed 's,^,dom=,' \
	| xargs -n 1 echo "$* type=a"
}

deploy_pre() { set -eu
	local line

	mkdir -p "$dest/etc/monitower"

	adm-db "$etc/db/host/ip" get pub=true host ip | while read host ip; do
		adm list "host/$host" | while IFS=' /' read type name vars; do

			line="host=$host ip=$ip check=$name $vars"

			case $type/$name in
			(monitor/dns) _monitower_dns $line ;;
			(monitor/*) echo "$line" ;;
			(*) continue ;;
			esac
		done
	done >$dest/etc/monitower/queue
}
