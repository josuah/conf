ZONE = josuah.net metairies.org z0.dn42
ZONE_NS = ns1

sync: ${ZONE_NS}
${ZONE_NS}:
	ns=$$(echo $@ | tr -cd 0-9) template conf/zone.conf \
	 | ssh $@.josuah.net 'exec cat >/var/nsd/etc/zone.conf'
	rsync -rt --delete zone/ $@.josuah.net:/var/nsd/zone/
	ssh $@.josuah.net exec nsd-control reload

conf: sign
sign zsk ksk: zone
	for zone in zone/*.*.zone; do doas dnssec $@ "$$zone"; done

zone: zone/sshfp.zone
	mkdir -p zone
	(cd conf/zone && template ${ZONE:=.zone}) | (cd zone && zone)
	cat zone/sshfp.zone >>zone/josuah.net.zone
	cat zone/sshfp.zone >>zone/z0.dn42.zone

zone/sshfp.zone:
	dnssec sshfp conf/zone/josuah.net.zone | sort -o $@

.PHONY: zone
