export tsig="$(adm-db "$db/dns-var" get pass | tr -d '\n' | openssl base64 -e)"
export other="$(adm-db "$db/dns-ns" get mode host="$host" | tr xfr_uth uth_xfr)"

deploy_pre() { set -eu
	mkdir -p "$dest/var/nsd/zones/master"

	for soa in $(adm-db "$db/dns-soa" get soa); do
		(cd "$etc" && zone=$soa adm-db "$conf/zone" template) \
			>$dest/var/nsd/zones/master/$soa
	done
}

deploy_post() { set -eu
	send "pkill -HUP nsd"
}
