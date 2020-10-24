deploy_pre() { set -u
	exec >$dest/etc/monitower.conf

	# http
	dbase "$db/http-vhost" get host vhost \
	 | while read host vhost; do
		sed='s,^[[:space:]]*(server|match)[[:space:]]"([^"]*)".*,\2, p'
		sed -rn "$sed" "$etc/mod/http/etc/httpd/$vhost.conf" \
		 | while read dom; do
			echo "cmd=check-http name=http-$vhost host=$host vhost=$vhost url=https://$dom/"
		done
	done

	# dns
	dbase "$db/dns-alias" get dom host soa \
	 | while read dom host soa; do
		[ "$dom" = @ ] && dom=$soa || dom=$dom.$soa
		q="host=$host dom=$dom"

		dbase "$etc/host/$host/db" get ip pub=true v=4 \
		 | while read ip; do
			echo "cmd=check-dns name=dns-$dom type=a ip=$ip host=$host dom=$dom"
		done

		dbase "$etc/host/$host/db" get ip pub=true v=6 \
		 | while read ip; do
			echo "cmd=check-dns name=dns-$dom type=aaaa ip=$ip host=$host dom=$dom"
		done
	done

	# smtp
	dbase "$db/dns-mx" get host \
	 | while read host; do
		dbase "$db/dns-soa" get soa mx=true \
		 | while read soa; do
			ip=$(dbase "$etc/host/$host/db" get ip pub=true v=4 | sed q)
			echo "cmd=check-mail name=smtp host=$host ip=$ip mail=monitor@$soa"
		done
	done
}
