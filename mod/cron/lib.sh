
deploy_post() { set -eu
	cat /etc/crontab.d/* >/etc/crontab
	pkill -HUP cron
}
