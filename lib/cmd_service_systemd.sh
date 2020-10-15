
cmd_service_install() { set -eu
	send "systemctl enable '$name'"
}

cmd_service_uninstall() { set -eu
	send "systemctl disable '$name'"
}

cmd_service_start() { set -eu
	send "systemctl start '$name'"
}

cmd_service_stop() { set -eu
	send "systemctl stop '$name'"
}

cmd_service_restart() { set -eu
	send "systemctl restart '$name'"
}

cmd_service_reload() { set -eu
	send "systemctl reload '$name'"
}

cmd_service_status() { set -eu
	send "systemctl status '$name'"
}
