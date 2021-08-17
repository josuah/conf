ZONE = z0.is z0.dn42 josuah.net metairies.org
ZONE_NS = ns1 ns2 ns3

conf: sign
sync: ${ZONE_NS}

${ZONE_NS}:
	ns=$$(echo $@ | tr -cd 0-9) template conf/nsd.conf \
	 | ssh $@.z0.is 'exec cat >/var/nsd/etc/nsd.conf'
	exec rsync -rt --delete zone/ $@.z0.is:/var/nsd/zone/
	exec ssh $@.z0.is exec nsd-control reload

sign zsk ksk: zone
	for zone in zone/*.*.zone; do doas dnssec $@ "$$zone"; done

zone: zone/sshfp.zone
	exec mkdir -p zone
	(cd conf/zone && template ${ZONE:=.zone}) | (cd zone && zone)
	exec cat zone/sshfp.zone >>zone/z0.is.zone
	exec cat zone/sshfp.zone >>zone/z0.dn42.zone

zone/sshfp.zone:
	dnssec sshfp conf/zone/z0.is.zone | sort -o $@

.PHONY: zone
