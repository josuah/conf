
cmd_service_install() { set -eu
	echo "$1=YES" >"/etc/rc.conf.d/$1"
}

cmd_service_uninstall() { set -eu
	rm "/etc/rc.conf.d/$1"
}

cmd_service_start() { set -eu
	"/etc/rc.d/$1" start
}

cmd_service_stop() { set -eu
	"/etc/rc.d/$1" stop
}

cmd_service_restart() { set -eu
	"/etc/rc.d/$1" restart
}

cmd_service_reload() { set -eu
	"/etc/rc.d/$1" reload
}

cmd_service_status() { set -eu
	"/etc/rc.d/$1" status
}
