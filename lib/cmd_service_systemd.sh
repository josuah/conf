
cmd_service_install() { set -eu
	send "systemctl enable '$1'"
}

cmd_service_uninstall() { set -eu
	send "systemctl disable '$1'"
}

cmd_service_start() { set -eu
	send "systemctl start '$1'"
}

cmd_service_stop() { set -eu
	send "systemctl stop '$1'"
}

cmd_service_restart() { set -eu
	send "systemctl restart '$1'"
}

cmd_service_reload() { set -eu
	send "systemctl reload '$1'"
}

cmd_service_status() { set -eu
	send "systemctl status '$1'"
}
