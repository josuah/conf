awk '{ printf("%40-s %s\n", $$2, $$1) }' rr.host >hosts
awk -f data.awk rr.soa rr.host rr.alias rr.service rr.mx rr.ns >data
tinydns-data
awk -f push.awk rr.ns