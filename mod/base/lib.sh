deploy_post() { set -eu
	send "
		touch "$HOME/.ssh/config_local"

		printf '\n  %s\n\n' \"\$(uname -srnm)\" >/etc/motd

		mkdir -p /var/unbound/db
		chown _unbound: /var/unbound/db
		unbound-anchor -vvv -a /var/unbound/db/root.key

		cat /etc/crond/* >/etc/crontab
		pkill -HUP cron

		cat /etc/syslog/* >/etc/syslog.conf
		sed -n 's,^[^#/]*/,/,p' /etc/syslog.conf | xargs touch
		sed -n 's,^[^#/]*/,/,p' /etc/syslog.conf | xargs chmod 6400
		sed -n 's,^[^#/]*/,/,p' /etc/syslog.conf | xargs chown root:
		pkill -HUP syslogd

		touch /etc/hosts.local
		cat /etc/hosts.local >>/etc/hosts

		cat /etc/newsyslog/* >/etc/newsyslog.conf

		cat /etc/login/* >/etc/login.conf

		cat /etc/inetd/* >/etc/inetd.conf
	"
}
