deploy_post() { set -eu
	scp -qr home/.??* "$host:/root"

	send "
                mkdir -p "$HOME/.ssh/sock"
                touch "$HOME/.ssh/config_local"

		mkdir -p /var/unbound/db
		chown _unbound: /var/unbound/db
		unbound-anchor -vvv -a /var/unbound/db/root.key

		cat /etc/crontab.d/* >/etc/crontab
		pkill -HUP cron

		cat /etc/syslog.d/* >/etc/syslog.conf
		sed -n 's,^[^#/]*/,/,p' /etc/syslog.conf | xargs touch
		sed -n 's,^[^#/]*/,/,p' /etc/syslog.conf | xargs chmod 6400
		sed -n 's,^[^#/]*/,/,p' /etc/syslog.conf | xargs chown root:
		pkill -HUP syslogd

		cat /etc/newsyslog.d/* >/etc/newsyslog.conf

		cat /etc/inetd.d/* >/etc/inetd.conf
	"
}
