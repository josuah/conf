export tsig="$(dbase "$db/dns-var" get pass | tr -d '\n' | openssl base64 -e)"
export other="$(dbase "$db/dns-ns" get mode host="$host" | tr xfr_uth uth_xfr)"

deploy_pre() { set -eu
	mkdir -p "$dest/var/nsd/zones/auth" "$dest/var/nsd/zones/axfr"

	for soa in $(dbase "$db/dns-soa" get soa); do
		(cd "$etc" && zone=$soa dbase "$conf/zone" template) \
			>$dest/var/nsd/zones/auth/$soa
	done
}

deploy_post() { set -eu
	send "
		chown -R _nsd: /var/nsd/*
		pkill -HUP nsd
	"
}
