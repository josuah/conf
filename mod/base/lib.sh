deploy_pre() { set -eu
	scp -qr home/.??* "$host:/root"
	send "	mkdir -p "$HOME/.ssh/sock"
		touch "$HOME/.ssh/config_local"
	"
}

deploy_post() { set -eu
	send "	cat /etc/crontab.d/* >/etc/crontab
		pkill -HUP cron
	"
}
