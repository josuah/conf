
cmd_service_install() { set -eu
	send "echo '$name=YES' >'/etc/rc.conf.d/$name'"
}

cmd_service_uninstall() { set -eu
	send "rm '/etc/rc.conf.d/$name'"
}

cmd_service_start() { set -eu
	send "'/etc/rc.d/$name' start"
}

cmd_service_stop() { set -eu
	send "'/etc/rc.d/$name' stop"
}

cmd_service_restart() { set -eu
	send "'/etc/rc.d/$name' restart"
}

cmd_service_reload() { set -eu
	send "'/etc/rc.d/$name' reload"
}

cmd_service_status() { set -eu
	send "'/etc/rc.d/$name' status"
}
