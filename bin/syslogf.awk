#!/usr/bin/awk -f
# create all log directories and log files with the right permissions

BEGIN {
	ARGV[1] = "/etc/syslog.conf"
	ARGC = 2

	system("exec install -d -o0 -g0 -m755 /var/log")
	system("exec rm -f /var/log/messages /var/log/authlog /var/log/daemon")
	system("exec rm -f /var/log/xferlog /var/log/lpd-errs /var/log/maillog")
	system("exec rm -f /var/cron/log")
}

/^[ \t]*[^ \t#]/ && $2 ~ "/" {
	system("exec touch '"$2"'")
	system("exec chmod 640 '"$2"'")
	system("exec chown 0:0 '"$2"'")
}

END {
	system("exec pkill -HUP syslogd")
}
