
cmd_service_enable() { set -eu
	systemctl enable "$1"
}

cmd_service_disable() { set -eu
	systemctl disable "$1"
}

cmd_service_start() { set -eu
	systemctl start "$1"
}

cmd_service_stop() { set -eu
	systemctl stop "$1"
}

cmd_service_restart() { set -eu
	systemctl restart "$1"
}

cmd_service_reload() { set -eu
	systemctl reload "$1"
}

cmd_service_status() { set -eu
	systemctl status "$1"
}
