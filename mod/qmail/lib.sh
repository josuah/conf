export uid="$(id -u mail)"
export gid="$(id -g mail)"

deploy_pre() { set -eu
	mkdir -p /var/qmail/alias /var/qmail/control /var/qmail/users \
		/etc/qmail /var/spool

	ln -fs /var/qmail/alias /var/qmail/control /var/qmail/users \
		/etc/qmail

	ln -fs /var/qmail/queue /etc/qmail/qmail
	mv -f /etc/qmail/qmail /var/spool

	hostname >/etc/qmail/control/me
}

deploy_post() { set -eu
	send "
		cd /etc/qmail/users
		qmail-newu
		pkill -HUP qmail-start
		pkill -HUP inetd
	"
}
