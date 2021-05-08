ZONE = z0.is z0.dn42 josuah.net metairies.org
NS = ns1.z0.is ns2.z0.is

mk/zone: sign
mk/zone/sync: ${NS}

mk/zone/clean:
	exec rm -f zone/*

${NS}:
	template conf/nsd/nsd.conf | ssh $@ 'exec cat >/var/nsd/etc/nsd.conf'
	exec rsync -rt --delete zone/ $@:/var/nsd/zones/
	exec ssh $@ exec nsd-control reload

sign zsk ksk: zone
	for zone in zone/*.*.zone; do doas dnssec $@ "$$zone"; done

zone: zone/sshfp.zone
	exec mkdir -p zone
	(cd conf/zone && template ${ZONE:=.zone}) | (cd zone && zone)
	exec cat zone/sshfp >>zone/z0.is.zone
	exec cat zone/sshfp >>zone/z0.dn42.zone

zone/sshfp.zone:
	dnssec sshfp conf/zone/z0.is.zone | sort -o $@

.PHONY: zone
