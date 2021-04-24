#!/usr/bin/awk -f

# configure point-to-point wireguard tunnels for use with dynamic
# routing protocols

function print(table, name, file) {
	print
}

BEGIN {
	port = 51820 # incremented by 1 for each extra interface

	hostid = ARGV[1]
	for (i = 1; i < ARGC; i++) ARGV[i] = ARGV[i + 1]
	ARGC--

	"exec hostname -s" | getline hostname
	"exec uname" | getline uname
	system("exec mkdir -p -m 700 /etc/wireguard")
	system("exec rm -f /etc/wireguard/wg[0-9]*.conf")

	file = "/etc/wireguard/interface.conf"
	if (system("exec test -f '"file"'") > 0) {
		"exec openssl rand -base64 32" | getline key
		print "[Interface]" >>file
		print "PrivateKey = "key >>file
		print "HostID = "hostid >>file
	}

	while (getline <"/etc/wireguard/interface.conf" > 0) {
		sub("[\t ]*=[\t ]*", " ")
		interface[$1] = $2
	}

	if (uname == "Linux") {
		print interface["privatekey"] | "exec wg pubkey"
		"exec wg pubkey" | getline interface["publickey"]
	}
	if (uname == "OpenBSD") {
		cmd = "exec ifconfig wg999999 create wgport 51820 wgkey "
		system(cmd interface["privatekey"])
		while (("exec ifconfig wg999999" | getline) > 0)
			if (tolower($1) = "wgpubkey")
				interface["pubkey"] = $2
	}
}

FNR == 1 {
	sub(".*/", "", FILENAME)
	sub(".conf$", "", FILENAME)
}

FILENAME == hostname {
	next
}

{
	text[FILENAME] = text[FILENAME] $0 "\n"
	sub("[\t ]*=[\t ]*", " ")
	conf[FILENAME" "$1] = $2
}

END {
	if (uname == "OpenBSD")
		system("exec ifconfig wg999999 destroy")

	for (peer in text) {
		peerid = conf["peer" hostid"]
		file = "/etc/wireguard/wg"peerid".conf"

		print "[Interface]" >>file
		system("exec cat /etc/wireguard/interface.conf") >>file
		print "ListenPort = "(port + peerid)
		print "" >>file
		print text[peer] >>file
	}

	print "PublicKey = "interface["publickey"]
	print "HostID = "interface["hostid"]
}
