export tsig="$(adm-db "$db/dns-var" get pass | tr -d '\n' | openssl base64 -e)"
export other="$(adm-db "$db/dns-ns" get mode host="$host" | tr xfr_uth uth_xfr)"

deploy_pre() { set -eu
	mkdir -p "$dest/var/nsd/zones/auth" "$dest/var/nsd/zones/axfr"

	for soa in $(adm-db "$db/dns-soa" get soa); do
		(cd "$etc" && zone=$soa adm-db "$conf/zone" template) \
			>$dest/var/nsd/zones/auth/$soa
	done
}

deploy_post() { set -eu
	send "
		chown -R _nsd: /var/nsd/*
		pkill -HUP nsd
	"
}
