ZONE_NS = ns1

sync: ${ZONE_NS}
${ZONE_NS}:
	rsync -rt --delete zone/ $@:/var/nsd/zones/master/
	ssh $@ exec nsd-control reload

conf: sign
sign zsk ksk: zone
	for zone in zone/*.*.zone; do dnssec $@ "$$zone"; done

zone: zone/sshfp.zone
	mkdir -p zone
	(cd conf/zone && template ${ZONE:=.zone}) | (cd zone && zone)
	cat zone/sshfp.zone >>zone/josuah.net.zone

zone/sshfp.zone:
	mkdir -p zone
	dnssec sshfp conf/zone/josuah.net.zone | sort -o $@

.PHONY: zone
