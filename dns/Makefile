MAIN = z0.is

zone: rrdata.zone sshfp.zone
	mkdir -p zone
	awk -f rrdata.awk rrdata.zone
	cat sshfp.zone >>zone/$$(awk '$$1=="$$MAIN" {print$$2}' rrdata.zone)

sshfp.zone: rrdata.zone
	mkdir -p zone
	awk '$$3 == "HOST" && !uniq[$$1]++ { print$$1 }' rrdata.zone \
	 | xargs -n1 ssh-keygen -r >$@

keygen:


sign: sshfp keygen
	bin/sign

.PHONY: zone
