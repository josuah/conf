
deploy_post() { set -eu
{
	echo "#Min	Hour	DoM	Mon	DoW	User	Command"
	for user in $(ls /etc/crontab.d/); do
		cat "/etc/crontab.d/$user/"* | while read t1 t2 t3 t4 t5 cmd; do
			printf '%s\t' "$t1" "$t2" "$t3" "$t4" "$t5"
			printf '%s\t%s\n' "$user" "$cmd"
		done
	done
}  >/etc/crontab

	pkill -HUP cron
}
