
deploy_post() { set -eu
	echo "#Min	Hour	DoM	Mon	DoW	User	Command" \
	| cat - /etc/crontab.d/* >/etc/crontab
	pkill -HUP cron
}
