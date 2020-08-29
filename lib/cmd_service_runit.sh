
cmd_service_enable() {
	ln -sf "/etc/runit/sv/$1" "/run/runit/service"
}

cmd_service_disable() {
	rm -f "/run/runit/service/$1"
}

cmd_service_start() {
	sv up "$1"
}

cmd_service_stop() {
	sv down "$1"
}

cmd_service_status() {
	sv status "$1"
}
