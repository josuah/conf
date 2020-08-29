
cmd_service_enable() {
	rc-update add "$1" default
}

cmd_service_disable() {
	rc-update del "$1" default
}

cmd_service_start() {
	rc-service start "$1"
}

cmd_service_stop() {
	rc-service stop "$1"
}

cmd_service_status() {
	rc-service status "$1"
}
