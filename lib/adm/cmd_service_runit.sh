
cmd_service_enable() { set -eu
	ln -sf "/etc/runit/sv/$1" "/run/runit/service"
}

cmd_service_disable() { set -eu
	rm -f "/run/runit/service/$1"
}

cmd_service_start() { set -eu
	sv start "$1"
}

cmd_service_stop() { set -eu
	sv stop "$1"
}

cmd_service_restart() { set -eu
	sv restart "$1"
}

cmd_service_reload() { set -eu
	sv reload "$1"
}

cmd_service_status() { set -eu
	sv status "$1"
}
