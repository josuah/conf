MAIN = $$(awk '$$1=="$$MAIN" {print$$2}' rrdata.zone)

zone: rrdata.zone sshfp.zone
	mkdir -p zone
	cd zone && rrzone ${PWD}/rrdata.zone
	cat sshfp.zone >>zone/${MAIN}.zone

sshfp.zone: rrdata.zone
	mkdir -p zone
	awk '$$3 == "HOST" && !uniq[$$1]++ { print$$1 }' rrdata.zone \
	 | xargs -n1 ssh-keygen -r >$@

sign:
	for zone in zone/*; do sh -eu sign.sh "$$zone"; done

sign: zone
	bin/sign

.PHONY: zone
.SUFFIX: .zone .zone.signed
