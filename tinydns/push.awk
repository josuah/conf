#!/usr/bin/awk -f

FILENAME == "rr.host" {
	ip[$1] = $2
}

FILENAME == "rr.ns" {
	cmd = sprintf("scp 'data.cdb' 'root@[%s]:/etc/tinydns/data.cdb'", ip[$1])
	print("+", cmd)
	system(cmd)
}
