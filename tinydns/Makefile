all: hosts push

push: Makefile data.cdb rr.host rr.ns
	awk -f push.awk rr.host rr.ns

data = rr.soa rr.host rr.alias rr.service rr.mx rr.ns
data: Makefile data.awk ${data}
	awk -f data.awk ${data} >$@

data.cdb: Makefile data
	tinydns-data

hosts: Makefile data rr.host
	awk '{ printf("%40-s %s\n", $$2, $$1) }' rr.host >hosts

clean:
	rm -f data data.cdb
