
cmd_service_install() { set -eu
	send "ln -sf '/etc/runit/sv/$1' /run/runit/service"
}

cmd_service_uninstall() { set -eu
	send "rm -f '/run/runit/service/$1'"
}

cmd_service_start() { set -eu
	send "sv start '$1'"
}

cmd_service_stop() { set -eu
	send "sv stop '$1'"
}

cmd_service_restart() { set -eu
	send "sv restart '$1'"
}

cmd_service_reload() { set -eu
	send "sv reload '$1'"
}

cmd_service_status() { set -eu
	send "sv status '$1'"
}
