
cmd_service_enable() {
	ln -sf "/etc/runit/sv/$1" "/run/runit/service"
}

cmd_service_disable() {
	rm -f "/run/runit/service/$1"
}

cmd_service_start() {
	sv start "$1"
}

cmd_service_stop() {
	sv stop "$1"
}

cmd_service_restart() {
	sv restart "$1"
}

cmd_service_reload() {
	sv reload "$1"
}

cmd_service_status() {
	sv status "$1"
}
