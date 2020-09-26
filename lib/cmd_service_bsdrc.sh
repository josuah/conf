
cmd_service_install() { set -eu
	send "echo '$1=YES' >'/etc/rc.conf.d/$1'"
}

cmd_service_uninstall() { set -eu
	send "rm '/etc/rc.conf.d/$1'"
}

cmd_service_start() { set -eu
	send "'/etc/rc.d/$1' start"
}

cmd_service_stop() { set -eu
	send "'/etc/rc.d/$1' stop"
}

cmd_service_restart() { set -eu
	send "'/etc/rc.d/$1' restart"
}

cmd_service_reload() { set -eu
	send "'/etc/rc.d/$1' reload"
}

cmd_service_status() { set -eu
	send "'/etc/rc.d/$1' status"
}
