
cmd_service_install() { set -eu
	rc-update add "$1" default
}

cmd_service_uninstall() { set -eu
	rc-update del "$1" default
}

cmd_service_start() { set -eu
	rc-service start "$1"
}

cmd_service_stop() { set -eu
	rc-service stop "$1"
}

cmd_service_restart() { set -eu
	rc-service restart "$1"
}

cmd_service_reload() { set -eu
	rc-service reload "$1"
}

cmd_service_status() { set -eu
	rc-service status "$1"
}
