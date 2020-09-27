deploy_pre() { set -eu
	send "ls /etc/ssl/acme" | sed 's,^,dom=,' >$etc/host/$host/db.cert
}
