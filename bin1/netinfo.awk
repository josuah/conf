#!/usr/bin/awk -f
# utility to convert between various IP formats

function max(a, b) { return a > b ? a : b }
function min(a, b) { return a < b ? a : b }

# simplified wireshark code

function oui_shorten(name,
	segment, i)
{
	name = tolower(name)
	gsub("&", " and ", name)
	gsub("[^a-z0-9 ]", " ", name)
	gsub(" +", " ", name)
	sub("^ ", "", name)
	sub(" $", "", name)
	while (sub(" (" \
	 "a s" "|ab" "|ag" "|b ?v" "|co" "|company" "|corp" "|corporation" \
	 "|de c ?v" "|gmbh" "|holding" "|inc" "|incorporated" "|jsc" "|kg" \
	 "|k k" "|limited" "|llc" "|ltdf" "|n ?v" "|oao" "|of" "|ooo" "|oy" \
	 "|oyj" "|plc" "|pty" "|pvt" "|s ?a ?r ?l" "|s ?a" "|s ?p ?a" "|sp ?k" \
	 "|s ?r ?l" "|systems" "|the" "|zao" "|z ?o ?o" \
	 ")$", " ", name));
	split(name, segment, " ")
	name = ""
	for (i = 1; i in segment; i++)
		name = name toupper(substr(segment[i], 1, 1)) substr(segment[i], 2)
	return name
}

function mac_oui(mac)
{
	url = "http://standards-oui.ieee.org/oui/oui.csv"
	if (system("test -f /var/tmp/oui.csv") > 0)
		if (system("curl -L -o /var/tmp/oui.csv " url) != 0)
			exit(1)
	gsub("[^a-fA-F0-9]", "", mac)
	mac = toupper(substr(mac, 1, 6))
	FS = ","
	while (getline <"/var/tmp/oui.csv")
		if ($2 == mac)
			return oui_shorten($3)
}

function mac_eui64(mac)
{
	mac = tolower(mac)
	gsub("[:-]", "", mac)
	return sprintf("fe80::%s:%s:%s:%s",
	 substr(mac, 1, 1) XOR2[substr(mac, 2, 1)] substr(mac, 3, 2),
	 substr(mac, 5, 2) "ff",
	 "fe" substr(mac, 7, 2),
	 substr(mac, 9, 2) substr(mac, 11, 2))
}

function ip6_hex(ip6,
	ar, out)
{
	sub("::", substr("::::::::", split(ip6, ar, ":") - 1), ip6)
	split(ip6, ar, ":")
	for (i = 1; i <= 8; i++)
		out = out substr("0000" ar[i], length(ar[i]) + 1)
	return out
}

function ip6_rev(ip6,
	out)
{
	ip6 = ip6_hex(ip6)
	for (i = 4 * 8; i > 0; i--)
		out = out substr(ip6, i, 1)"."
	return out"ip6.arpa"
}

function hex_ip6(hex,
	beg, end, x)
{
	beg = substr(hex, 1, 16);	end = substr(hex, 17)
	x += sub("(0000)+$", "", beg);	x += sub("^(0000)+", "", end)
	gsub("....", ":&", beg);	gsub("....", ":&", end)
	gsub(":0*", ":", beg);		gsub(":0*", ":", end)
	return substr(beg, 2) (x ? ":" : "") end
}

function int_ip4(n)
{
	return (int(n/256^3) % 256)"."(int(n/256^2) % 256) \
	  "."(int(n/256^1) % 256)"."(int(n/256^0) % 256)
}

function ip4_int(ip4,
	ar, n)
{
	if (split(ip4, ar, ".") != 4) return
	return ar[1]*256^3 + ar[2]*256^2 + ar[3]*256^1 + ar[4]*256^0
}

function usage()
{
	print "usage: netinfo hex <ip6>" >"/dev/stderr"
	print "       netinfo int <ip4>" >"/dev/stderr"
	print "       netinfo rev <ip6>" >"/dev/stderr"
	print "       netinfo ip4 <int>" >"/dev/stderr"
	print "       netinfo ip6 <hex>" >"/dev/stderr"
	print "       netinfo oui <mac>" >"/dev/stderr"
	print "       netinfo eui64 <mac>" >"/dev/stderr"
	exit(1)
}

BEGIN {
	XOR2["0"]=0; XOR2["1"]=0; XOR2["2"]=2; XOR2["3"]=2
	XOR2["4"]=0; XOR2["5"]=0; XOR2["6"]=2; XOR2["7"]=2
	XOR2["8"]=0; XOR2["9"]=0; XOR2["a"]=2; XOR2["b"]=2
	XOR2["c"]=0; XOR2["d"]=0; XOR2["e"]=2; XOR2["f"]=2

	if (ARGC != 3) usage()
	else if (ARGV[1] == "hex") print ip6_hex(ARGV[2])
	else if (ARGV[1] == "int") print ip4_int(ARGV[2])
	else if (ARGV[1] == "rev") print (v==6) ? ip6_rev(ARGV[2]) : ip6_rev(ARGV[2])
	else if (ARGV[1] == "ip4") print int_ip4(ARGV[2])
	else if (ARGV[1] == "ip6") print hex_ip6(ARGV[2])
	else if (ARGV[1] == "oui") print mac_oui(ARGV[2])
	else if (ARGV[1] == "eui64") print mac_eui64(ARGV[2])
	else usage()
}
