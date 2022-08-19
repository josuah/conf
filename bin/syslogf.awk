#!/usr/bin/awk -f
# create all log directories and log files with the right permissions

BEGIN {
	ARGV[1] = "/etc/syslog.conf"
	ARGC = 2
}

/^[ \t]*[^ \t#]/ && $2 ~ "/" {
	print $2
	system("exec touch '"$2"'")
	system("exec chmod 640 '"$2"'")
	system("exec chown 0:0 '"$2"'")
}

END {
	system("exec pkill -HUP syslogd")
}
