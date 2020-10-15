
cmd_service_install() { set -eu
	send "ln -sf '/etc/runit/sv/$name' /run/runit/service"
}

cmd_service_uninstall() { set -eu
	send "rm -f '/run/runit/service/$name'"
}

cmd_service_start() { set -eu
	send "sv start '$name'"
}

cmd_service_stop() { set -eu
	send "sv stop '$name'"
}

cmd_service_restart() { set -eu
	send "sv restart '$name'"
}

cmd_service_reload() { set -eu
	send "sv reload '$name'"
}

cmd_service_status() { set -eu
	send "sv status '$name'"
}
