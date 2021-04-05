rr = rr.soa rr.host rr.ns rr.mx rr.alias

all: data.awk ${rr}
	awk -f data.awk ${rr}
