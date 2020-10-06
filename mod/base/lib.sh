deploy_pre() { set -eu
#	if [ ! -f /etc/ssh/ssh_host_ed25519_key ]; then
#		ssh-keygen -A
#	fi
#
#		mkdir -p	"$dest/root/.ssh/sock"
#		touch		"$dest/root/.ssh/authorized_keys"
#		chmod 644 	"$dest/root/.ssh/"*
#		chmod 700	"$dest/root/.ssh/"*"/"
#		chmod 755	"$dest/root/.ssh"
#		chown -R 0:0	"$dest/root/.ssh"
#		cat keys/*	>$dir/.ssh/authorized_keys
#	done
}

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

		cat /etc/login.d/* >/etc/login.conf

		cat /etc/inetd.d/* >/etc/inetd.conf
	"
}
