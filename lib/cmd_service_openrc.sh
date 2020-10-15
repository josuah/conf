
cmd_service_install() { set -eu
	send "rc-update add '$name' default'"
}

cmd_service_uninstall() { set -eu
	send "rc-update del '$name' default'"
}

cmd_service_start() { set -eu
	send "rc-service start '$name'"
}

cmd_service_stop() { set -eu
	send "rc-service stop '$name'"
}

cmd_service_restart() { set -eu
	send "rc-service restart '$name'"
}

cmd_service_reload() { set -eu
	send "rc-service reload '$name'"
}

cmd_service_status() { set -eu
	send "rc-service status '$name'"
}
