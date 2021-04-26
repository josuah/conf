ZONE = z0.is z0.dn42 \
  josuah.net metairies.org

mk/zone:

mk/zone/sync: sign
	rsync -vrt --delete zones/ ns1.z0.is:/var/nsd/zones/
	rsync -vrt --delete zones/ ns2.z0.is:/var/nsd/zones/
	ssh ns1.z0.is make -C /etc/adm mk/dns
	ssh ns2.z0.is make -C /etc/adm mk/dns

mk/zone/clean:
	exec rm -f zones/*

sign zsk ksk: zone
	for zones in zones/*.*.zone; do doas dnssec $@ "$$zones"; done

zone: zones/sshfp
	exec mkdir -p zones
	(cd conf/zone && template ${ZONE:=.zone}) | (cd zones && zone)
	exec cat zones/sshfp >>zones/z0.is.zone
	exec cat zones/sshfp >>zones/z0.dn42.zone

zones/sshfp:
	dnssec sshfp conf/zone/z0.is.zone | sort -o $@
