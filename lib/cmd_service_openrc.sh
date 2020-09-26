
cmd_service_install() { set -eu
	send "rc-update add '$1' default'"
}

cmd_service_uninstall() { set -eu
	send "rc-update del '$1' default'"
}

cmd_service_start() { set -eu
	send "rc-service start '$1'"
}

cmd_service_stop() { set -eu
	send "rc-service stop '$1'"
}

cmd_service_restart() { set -eu
	send "rc-service restart '$1'"
}

cmd_service_reload() { set -eu
	send "rc-service reload '$1'"
}

cmd_service_status() { set -eu
	send "rc-service status '$1'"
}
