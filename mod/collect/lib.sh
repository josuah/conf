deploy_pre() { set -eu
	send "ls /etc/ssl/*.crt" | sed -r 's,.*/(.*).crt,dom=\1,' \
	  >$etc/host/$host/db.cert
}
