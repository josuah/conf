CONF = nsd/nsd.conf
ZONES = z0.is z0.dn42 \
  josuah.net metairies.org

mk/dns: ${CONF}
	exec rm -rf /var/nsd/zones
	exec mkdir -p /var/nsd
	exec cp -r zones /var/nsd

zones: sshfp
	exec mkdir -p zones
	(cd conf/zone && template ${ZONES:=.zone}) | (cd zones && zone)
	exec cat sshfp >>zones/z0.is.zone
	exec cat sshfp >>zones/z0.dn42.zone

sshfp:
	dnssec sshfp conf/zone/z0.is.zone | sort -o $@

sign zsk ksk:
	for zones in zones/*.*.zone; do dnssec $@ "$$zones"; done

mk/dns/clean:
	exec rm -f zones/*

mk/dns/sync:

.PHONY: zones

include mk/conf.inc
