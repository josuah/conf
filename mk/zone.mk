ZONE = z0.is z0.dn42 \
  josuah.net metairies.org

mk/zone:

mk/zone/sync: sign
	rsync -vrt --delete zones/ ns1.z0.is:/var/nsd/zones/
	rsync -vrt --delete zones/ ns2.z0.is:/var/nsd/zones/
	ssh ns1.z0.is make -C /etc/adm dns
	ssh ns2.z0.is make -C /etc/adm dns

sign zsk ksk: zone
	for zones in zones/*.*.zone; do dnssec $@ "$$zones"; done

zone: sshfp
	exec mkdir -p zones
	(cd conf/zone && template ${ZONE:=.zone}) | (cd zones && zone)
	exec cat sshfp >>zones/z0.is.zone
	exec cat sshfp >>zones/z0.dn42.zone

sshfp:
	dnssec sshfp conf/zone/z0.is.zone | sort -o $@

mk/zone/clean:
	exec rm -f zones/*

.PHONY: zone
